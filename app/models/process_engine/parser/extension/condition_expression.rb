class ProcessEngine::Parser::Extension::ConditionExpression
  attr_reader  :element

  def initialize(element)
    @element = element
  end

  def language
    element["language"]
  end

  def condition
    element.content
  end

  def type
    element["xsi:type"]
  end

  def resource
    element["camunda:resource"]
  end


  def self.factory(xelement)
    ce = xelement.at_xpath("bpmn2:conditionExpression")
    return nil unless ce
    new(ce)
  end

  def to_h
    {
      language: language,
      condition: condition,
      type: type,
      resource: resource
    }
  end
end
