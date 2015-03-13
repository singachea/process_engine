class ProcessEngine::Parser::UserTask < ProcessEngine::Parser::XmlNode
  def initialize(element)
    super(element)
  end

  def extension_elements
    # support [executionListener], [taskListener], [formField], [property], inputs_outputs
    custom_extension_elements(:execution_listeners, :task_listeners, :form_fields, :properties, :inputs_outputs)
  end

  def assignee
    element["camunda:assignee"]
  end

  def candidate_users
    (element["camunda:candidateUsers"].try(:split, ",") || []).map(&:strip).select(&:present?)
  end

  def candidate_groups
    (element["camunda:candidateGroups"].try(:split, ",") || []).map(&:strip).select(&:present?)
  end

  def to_h
    custom_ext = custom_extension_elements_hash(:execution_listeners, :task_listeners, :form_fields, :properties, :inputs_outputs)

    super.merge({
      extension: {
        common: custom_ext,
        assignee: assignee,
        candidate_users: candidate_users,
        candidate_groups: candidate_groups
      }
    })
  end

end
