class ProcessEngine::NodeDataInjection
  cattr_accessor :injected_classes

  # source object could be process instance object or process task object
  def self.node_options_data(process_definition_slug, node_id, source_object)
    # each class requires `implemented_node_ids`
    selected_class = (injected_classes || []).find { |icl| icl.implemented_node_ids.map(&:to_s).include?(node_id.to_s) && icl.process_definition_slug == process_definition_slug }
    return {} unless selected_class.present?

    # return value from here
    result = selected_class.forward_implementation_method(node_id, source_object)
    result.instance_of?(Hash) ? result : {}
  end
end
