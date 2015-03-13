class ProcessEngine::Parser::Extension::FormField
  attr_reader  :element

  def initialize(element)
    @element = element
  end

  def id
    element["id"]
  end

  def label
    element["label"]
  end

  def type
    element["type"]
  end

  def default_value
    element["defaultValue"]
  end

  def properties
    element.xpath("camunda:properties//camunda:property").each_with_object({}) do |prop, hash|
      hash[prop["id"]] = prop["value"]
    end
  end

  def validation
    element.xpath("camunda:validation//camunda:constraint").each_with_object({}) do |constraint, hash|
      hash[constraint["name"]] = constraint["config"]
    end
  end

  def to_h
    {
      id: id,
      label: label,
      type: type,
      default_value: default_value,
      properties: properties,
      validation: validation
    }
  end

  def self.factory(extension_element)
    data = extension_element.xpath("camunda:formData//camunda:formField").map{ |ff| new(ff) }
  end
end
