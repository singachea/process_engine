class ProcessEngine::Schema::Interceptor::ExclusiveGateway

  attr_reader :node, :options

  def initialize(node, options)
    @node = node
    @options = options
  end

  def execute
    # get the next branch from the options implemented
    next_node = target_of_next_sequence_flow(options[:exclusive_gateway_choice_value])

    # choose the default flow if not implemented
    next_node = choose_default_flow unless next_node

    return [] unless next_node # the flow get stuck if no implementation given or no default path
    [next_node]
  end

  def self.execute(node, options)
    new(node, options).execute
  end


  private

  def target_of_next_sequence_flow(value)
    branching_transition_id = node.node_extension.common_properties_kv[value]
    return nil unless branching_transition_id.present?

    node.transitions.find { |t| t.id == branching_transition_id }.try(:target)
  end

  def choose_default_flow
    df = node.node_extension.gateway_default_flow
    node.transitions.find { |t| t.id == df }.try(:target)
  end
end
