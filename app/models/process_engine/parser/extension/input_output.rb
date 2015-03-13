class ProcessEngine::Parser::Extension::InputOutput
  attr_reader  :element

  def initialize(element)
    @element = element
  end

  def input_parameters
    ProcessEngine::Parser::Extension::TransitionalParameter.factory(element, "inputParameter")
  end

  def output_parameters
    ProcessEngine::Parser::Extension::TransitionalParameter.factory(element, "outputParameter")
  end

  def to_h
    {
      input_parameters: input_parameters.map(&:to_h),
      output_parameters: output_parameters.map(&:to_h)
    }
  end

  def self.factory(extension_element)
    io = extension_element.at_xpath("camunda:inputOutput")
    return nil unless io
    new(io)
  end
end
