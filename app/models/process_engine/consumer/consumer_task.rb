class ProcessEngine::Consumer::ConsumerTask

  attr_reader :process_task, :node, :node_extension

  def initialize(process_task)
    @process_task = process_task
    @node = process_task.process_instance.process_definition.schema.node(process_task.state)
    @node_extension = @node.node_extension
  end

  def external_ref
    node_extension.common_properties_kv[:external_ref]
  end

end
