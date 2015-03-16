module ProcessEngine
  class ProcessTask < ActiveRecord::Base
    enum status: { pending: 0, finished: 1 }

    belongs_to :process_definition_node
    belongs_to :process_instance

    # list of operators http://www.postgresql.org/docs/9.4/static/functions-array.html
    scope :by_assignee, -> (assignee) { where(assignee: assignee) }
    scope :by_candidate_user, -> (candidate_user) { where("? = ANY(candidate_users)", candidate_user) }
    scope :by_all_candidate_users, -> (candidate_users) { where("candidate_users @> ARRAY[?]::varchar[]", candidate_users) }
    scope :by_any_candidate_users, -> (candidate_users) { where("candidate_users && ARRAY[?]::varchar[]", candidate_users) }

    scope :by_candidate_group, -> (candidate_group) { where("? = ANY(candidate_groups)", candidate_group) }
    scope :by_all_candidate_groups, -> (candidate_groups) { where("candidate_groups @> ARRAY[?]::varchar[]", candidate_groups) }
    scope :by_any_candidate_groups, -> (candidate_groups) { where("candidate_groups && ARRAY[?]::varchar[]", candidate_groups) }

    scope :by_user, -> (user) { where("assignee = ? OR ? = ANY(candidate_users)", user, user) }
    scope :by_user_or_groups, -> (user, groups) { where("assignee = ? OR ? = ANY(candidate_users) OR candidate_groups && ARRAY[?]::varchar[]", user, user, groups) }

    scope :by_status, -> (status) { where(status: status) }
    scope :by_state, -> (state) { where(state: state) }

    scope :desc, -> { order('id desc') }
    scope :asc, -> { order('id asc') }


    # available options :finisher, :data
    def complete(options)
      injected_data = ProcessEngine::NodeDataInjection.node_options_data(process_instance.process_definition.slug, state, self)
      process_instance.move_to_next_state(state, injected_data)

      opt = { finisher: options[:finisher], status: :finished }
      opt[:data] = options[:data] if options[:data].present?

      update!(opt)

      # enable service hooks
      node_ext = process_instance.process_definition.schema.node(state).node_extension
      ProcessEngine::Listener::Base.execute(process_instance, node_ext.common_execution_listeners, 'end')
      ProcessEngine::Listener::Base.execute(process_instance, node_ext.common_task_listeners, 'complete')
    end

    def self.spawn_new_task(pi, state, injected_data)
      injected_data ||= {}
      injected_data = ActiveSupport::HashWithIndifferentAccess.new(injected_data)

      node_ext = pi.process_definition.schema.node(state).node_extension
      assignee = injected_data[:assignee] || node_ext.user_task_assignee
      candidate_users = Array.wrap(injected_data[:candidate_users] || node_ext.user_task_candidate_users)
      candidate_groups = Array.wrap(injected_data[:candidate_groups] || node_ext.user_task_candidate_groups)

      create! assignee: assignee,
              candidate_users: candidate_users,
              candidate_groups: candidate_groups,
              state: state,
              process_instance_id: pi.id

      # enable service hooks for "start" & "create" event of execution_listeners & task_listeners
      ProcessEngine::Listener::Base.execute(pi, node_ext.common_execution_listeners, 'start')
      ProcessEngine::Listener::Base.execute(pi, node_ext.common_task_listeners, 'create')
    end


    def consumer_task
      ProcessEngine::Consumer::ConsumerTask.new(self)
    end

  end
end
