class ProcessEngine::Parser::Extension::TaskListener
  attr_reader  :element

  include ProcessEngine::Parser::Extension::Listener

  # available option for event: create, assignment, complete

  def initialize(element)
    @element = element
  end

  def self.factory(extension_element)
    extension_element.xpath("camunda:taskListener").map { |tl| new(tl) }
  end
end
