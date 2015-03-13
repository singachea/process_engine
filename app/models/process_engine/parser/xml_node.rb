class ProcessEngine::Parser::XmlNode
  TYPES_GATEWAY = %w(exclusiveGateway parallelGateway inclusiveGateway complexGateway)
  TYPES_EVENT = %w(startEvent endEvent)
  TYPES_TASK = %w(scriptTask userTask)
  TYPES_FLOW = %w(sequenceFlow)

  attr_reader :id, :name, :node_type, :element

  def initialize(element)
    @id = element["id"]
    @name = element["name"]
    @node_type = element.name
    @element = element
  end

  def incoming_strings
    element.xpath("bpmn2:incoming").map(&:content)
  end

  def outgoing_strings
    element.xpath("bpmn2:outgoing").map(&:content)
  end

  def extension_elements
    raise "Not imlpmented"
  end

  def documentation
    element.at_xpath("bpmn2:documentation").try(:content)
  end

  def type_gateway?
    TYPES_GATEWAY.include?(node_type)
  end

  def type_event?
    TYPES_EVENT.include?(node_type)
  end

  def type_task?
    TYPES_TASK.include?(node_type)
  end

  def type_flow?
    TYPES_FLOW.include?(node_type)
  end

  def to_h
    {
      node_id: id,
      node_type: node_type,
      name: name
    }
  end

  class << self
    def factory(element)
      case element.name
      when "startEvent"
        ProcessEngine::Parser::StartEvent.new(element)
      when "endEvent"
        ProcessEngine::Parser::EndEvent.new(element)
      when "userTask"
        ProcessEngine::Parser::UserTask.new(element)
      when "scriptTask"
        ProcessEngine::Parser::ScriptTask.new(element)
      when "parallelGateway"
        ProcessEngine::Parser::ParallelGateway.new(element)
      when "exclusiveGateway"
        ProcessEngine::Parser::ExclusiveGateway.new(element)
      when "complexGateway"
        ProcessEngine::Parser::ComplexGateway.new(element)
      when "inclusiveGateway"
        ProcessEngine::Parser::InclusiveGateway.new(element)
      when "sequenceFlow"
        ProcessEngine::Parser::SequenceFlow.new(element)
      else
        nil
      end
    end
  end

  private

  def custom_extension_elements(*extension_props)
    ext = element.at_xpath("bpmn2:extensionElements")
    return nil unless ext

    extension = ProcessEngine::Parser::Extension

    parser = {
      execution_listeners: ProcessEngine::Parser::Extension::ExecutionListener,
      task_listeners: ProcessEngine::Parser::Extension::TaskListener,
      form_fields: ProcessEngine::Parser::Extension::FormField,
      properties: ProcessEngine::Parser::Extension::Property,
      inputs_outputs: ProcessEngine::Parser::Extension::InputOutput
    }

    intersect = extension_props & parser.keys
    obj = (Struct.new *intersect).new
    intersect.each do |prop|
      obj[prop] = parser[prop].factory(ext)
    end

    obj
  end

  def custom_extension_elements_hash(*extension_props)

    ee = extension_elements
    return {} unless ee

    available_hash = {
      execution_listeners: ee.try(:execution_listeners).try(:map){ |item| item.to_h },
      task_listeners: ee.try(:task_listeners).try(:map){ |item| item.to_h },
      form_fields: ee.try(:form_fields).try(:map){ |item| item.to_h },
      properties: ee.try(:properties).try(:map){ |item| item.to_h },
      inputs_outputs: ee.try(:inputs_outputs).try(:to_h)
    }

    intersect = extension_props & available_hash.keys
    available_hash.slice(*intersect)
  end

end
