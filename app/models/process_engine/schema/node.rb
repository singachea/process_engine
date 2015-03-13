class ProcessEngine::Schema::Node
  module NodeType
    START_EVENT = "startEvent"
    END_EVENT = "endEvent"
    EXCLUSIVE_GATEWAY = "exclusiveGateway"
    USER_TASK = "userTask"
    SCRIPT_TASK = "scriptTask"
    PARALLEL_BRANCHING = "parallelGateway"

    COMPLEX_GATEWAY = "complexGateway"
  end

  COMPUTED_NODE_TYPES = [ NodeType::END_EVENT,
                          NodeType::EXCLUSIVE_GATEWAY,
                          NodeType::PARALLEL_BRANCHING,
                          NodeType::SCRIPT_TASK ]

  attr_reader :node_id, :node_type, :name, :extension, :owners, :transitions

  def initialize(node_hash)
    @node_id = node_hash.fetch(:node_id)
    @node_type = node_hash.fetch(:node_type)
    @name = node_hash.fetch(:name)
    @owners = node_hash.fetch(:owners, [])
    @extension = node_hash.fetch(:extension, {})
    @transitions = []
  end

  # all linked next nodes without considerting node type
  def next_nodes
    transitions.map(&:target)
  end

  def next_schedulable_nodes(options = {})

    nns = next_nodes
    if node_type == NodeType::EXCLUSIVE_GATEWAY
      ProcessEngine::Schema::Interceptor::ExclusiveGateway.execute(self, options)
    else
      nns
    end
  end

  def node_extension
    ProcessEngine::Schema::NodeExtension.new(self)
  end

end
