class ProcessEngine::Parser::Extension::ExecutionListener
  attr_reader  :element

  include ProcessEngine::Parser::Extension::Listener

  # available option for event: start, end

  def initialize(element)
    @element = element
  end

  def self.factory(extension_element)
    extension_element.xpath("camunda:executionListener").map { |el| new(el) }
  end
end
