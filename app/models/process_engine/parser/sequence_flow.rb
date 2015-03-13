class ProcessEngine::Parser::SequenceFlow < ProcessEngine::Parser::XmlNode
  def initialize(element)
    super(element)
  end

  def source_ref
    element["sourceRef"]
  end

  def target_ref
    element["targetRef"]
  end

  def condition_expression
    ProcessEngine::Parser::Extension::ConditionExpression.factory(element)
  end

  def extension_elements
    # support [executionListener], [property]
    custom_extension_elements(:execution_listeners, :properties)
  end

  def to_h
    custom_ext = custom_extension_elements_hash(:execution_listeners, :properties)

    super.merge({
      extension: {
        common: custom_ext,
        condition_expression: condition_expression.to_h
      },
      source_ref: source_ref,
      target_ref: target_ref,
    })
  end

end
