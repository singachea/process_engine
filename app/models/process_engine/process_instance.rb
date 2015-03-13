module ProcessEngine
  class ProcessInstance < ActiveRecord::Base
    enum status: { movable: 0, waiting: 1, finished: 2 } # check if required to check for branching

    belongs_to :process_definition
    has_many :process_tasks, dependent: :destroy
    # has_many :process_definition_nodes, through: :process_definition

    scope :desc, -> { order('id desc') }
    scope :asc, -> { order('id asc') }

    # options includes ({:exclusive_gateway_choice_value})
    def move_to_next_state(pdn_slug_state, options = {})
      move_to_next_cur_state(pdn_slug_state, [], options)
    end

    def start
      update_attributes!(states: [process_definition.starting_node])
      begin_process_instance
      self
    end

    private

    def begin_process_instance
      ProcessEngine::ProcessTask.spawn_new_task(self, states.first, { assignee: creator })
    end

    def move_to_next_cur_state(cur_state, previous_states = [], options = {})
      current_node = process_definition.schema.node(cur_state)
      schedulable_nodes = current_node.next_schedulable_nodes(options)

      case schedulable_nodes.count
      when 0
        update!(status: :finished, states: [cur_state]) # finish life cycle
      # when 1
      #   execute_single_next_movable_nodes(cur_state, previous_states, schedulable_nodes.first)
      else
        # more than one branching node ---> parallel tasks
        schedulable_nodes.each do |sn|
          execute_single_next_movable_nodes(cur_state, previous_states, sn)
        end
      end
    end

    def execute_single_next_movable_nodes(cur_state, previous_states, node)
      new_state = node.node_id

      injected_data = ProcessEngine::NodeDataInjection.node_options_data(process_definition.slug, new_state, self)

      # check if node can be computed (e.g. script task, or branching node)
      if ProcessEngine::Schema::Node::COMPUTED_NODE_TYPES.include?(node.node_type)
        # injected_data = ProcessEngine::NodeDataInjection.node_options_data(process_definition.slug, new_state, self)
        move_to_next_cur_state(new_state, previous_states + [cur_state], injected_data)

      elsif node.node_type == ProcessEngine::Schema::Node::NodeType::COMPLEX_GATEWAY

        unless states.include?(new_state)
          update!(states: (states | [new_state]) - ([cur_state] | previous_states))
        else
          # one state has already been reached, and we just need to move forward
          # injected_data = ProcessEngine::NodeDataInjection.node_options_data(process_definition.slug, new_state, self)
          move_to_next_cur_state(new_state, previous_states + [cur_state], injected_data)
        end
      else
        # this node requires action from user
        ProcessEngine::ProcessTask.spawn_new_task(self, new_state, injected_data)
        update!(states: (states | [new_state]) - ([cur_state] | previous_states))
      end
    end
  end
end
