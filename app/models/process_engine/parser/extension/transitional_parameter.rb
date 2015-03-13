class ProcessEngine::Parser::Extension::TransitionalParameter
  attr_reader  :element, :name

  def initialize(element)
    @element = element
    @name = element["name"]
  end

  def list
    l = element.xpath("camunda:list//camunda:value").map(&:content)
    l.present? ? l : nil
  end

  def map
    h = element.xpath("camunda:map//camunda:entry").each_with_object({}) do |item, hash|
      hash[item["key"]] = item.content
    end

    h.present? ? h : nil
  end

  def string
    element.elements.count == 0 ? element.content : nil
  end

  def script
    sct = element.at_xpath("camunda:script")
    return nil unless sct
    obj = (Struct.new(:script_format, :script_content)).new
    obj.script_format = sct["scriptFormat"]
    obj.script_content = sct.content
    obj
  end

  def type
    %w(list string map script).find {|item| send(item).present? }
  end

  def value
    send(type)
  end

  def to_h
    {
      type: type,
      value: value
    }
  end

  def self.factory(element, direction)
    element.xpath("camunda:#{direction}").map { |el| new(el) }
  end
end
