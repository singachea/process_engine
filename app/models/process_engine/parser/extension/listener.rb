module ProcessEngine::Parser::Extension::Listener
  def class_name
    element["class"]
  end

  def expression
    element["expression"]
  end

  def delegate_expression
    element["delegateExpression"]
  end

  def script
    sct = element.at_xpath("camunda:script")
    return nil unless sct
    obj = (Struct.new(:script_format, :script_content)).new
    obj.script_format = sct["scriptFormat"]
    obj.script_content = sct.content
    obj
  end

  def event
    element["event"]
  end

  def type
    %w(class_name expression delegate_expression script).find {|item| send(item).present? }
  end

  def value
    send(type)
  end

  def to_h
    {
      type: type,
      value: value,
      event: event
    }
  end

end
