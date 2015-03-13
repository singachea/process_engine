class ProcessEngine::Parser::EndEvent < ProcessEngine::Parser::XmlNode
  def initialize(element)
    super(element)
  end


  def extension_elements
    # support [executionListener], [property], :inputs_outputs
    custom_extension_elements(:execution_listeners, :properties, :inputs_outputs)
  end

  def to_h
    custom_ext = custom_extension_elements_hash(:execution_listeners, :properties, :inputs_outputs)

    super.merge({
      extension: {
        common: custom_ext
      }
    })
  end


end
