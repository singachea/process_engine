class ProcessEngine::Parser::ParallelGateway < ProcessEngine::Parser::XmlNode
  def initialize(element)
    super(element)
  end

  def extension_elements
    # support [executionListener], [property]
    custom_extension_elements(:execution_listeners, :properties)
  end

  def to_h
    custom_ext = custom_extension_elements_hash(:execution_listeners, :properties)
    super.merge({
      extension: {
        common: custom_ext
      }
    })
  end
end
