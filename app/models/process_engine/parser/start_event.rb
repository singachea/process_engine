class ProcessEngine::Parser::StartEvent < ProcessEngine::Parser::XmlNode
  def initialize(element)
    super(element)
  end

  def initiator
    element["camunda:initiator"]
  end

  def extension_elements
    # support [executionListener], [formField], [property]
    custom_extension_elements(:execution_listeners, :form_fields, :properties)
  end

  def to_h
    custom_ext = custom_extension_elements_hash(:execution_listeners, :form_fields, :properties)

    super.merge({
      extension: {
        common: custom_ext,
        initiator: initiator
      }
    })
  end


end
