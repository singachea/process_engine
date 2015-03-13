class ProcessEngine::Parser::Extension::Property
  attr_reader  :element, :name, :value

  def initialize(element)
    @element = element
    @name = element["name"]
    @value = element["value"]
  end

  def to_h
    {
      name: name,
      value: value
    }
  end

  def self.factory(extension_element)
    extension_element.xpath("camunda:properties//camunda:property").map { |el| new(el) }
  end
end
