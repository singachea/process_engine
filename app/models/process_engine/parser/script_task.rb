class ProcessEngine::Parser::ScriptTask < ProcessEngine::Parser::XmlNode
  def initialize(element)
    super(element)
  end

  def script_format
    element["scriptFormat"]
  end

  def resource
    element["camunda:resource"]
  end

  def script
    element.at_xpath("bpmn2:script").try(:content)
  end

  def extension_elements
    # support [executionListener], [property], inputs_outputs
    custom_extension_elements(:execution_listeners, :properties, :inputs_outputs)
  end

  def to_h
    custom_ext = custom_extension_elements_hash(:execution_listeners, :properties, :inputs_outputs)

    super.merge({
      extension: {
        common: custom_ext,
        script_format: script_format,
        resource: resource,
        script: script
      }
    })
  end


end
