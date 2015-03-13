class ProcessEngine::ProcessSchema
  attr_reader :nodes

  def initialize(process_definition)
    nodes_hash = process_definition.bpmn_json.fetch("nodes", [])
    @transitions_hash = process_definition.bpmn_json.fetch("transitions", [])
    initialize_graph(nodes_hash, @transitions_hash)
  end

  def node(node_id)
    nodes.find { |n| n.node_id == node_id }
  end

  def nodes_by_type(node_type)
    nodes.select{ |node| node.node_type == node_type }
  end

  private

  def initialize_graph(nodes_hash, transitions_hash)
    @nodes = nodes_hash.map{ |node| ProcessEngine::Schema::Node.new(ActiveSupport::HashWithIndifferentAccess.new(node)) }
    transitions_hash.each do |tn|
      source = node(tn["source_ref"]) || (fail "Can't find node #{tn["source_ref"]} in source_ref")
      target = node(tn["target_ref"]) || (fail "Can't find node #{tn["target_ref"]} in target_ref")
      source.transitions << ProcessEngine::Schema::Transition.new(ActiveSupport::HashWithIndifferentAccess.new(tn), source, target)
    end
  end


end
