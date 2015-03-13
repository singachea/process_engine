class ProcessEngine::Schema::NodeExtension
  attr_reader :extension

  def initialize(node)
    @node = node
    @extension = node.extension
  end

  def common
    extension.fetch("common", {})
  end

  def common_properties
    common.fetch("properties", [])
  end

  def common_properties_kv
    kv = common_properties.each_with_object({}) {|el, hash| hash[el["name"]] = el["value"] }
    ActiveSupport::HashWithIndifferentAccess.new(kv)
  end

  def common_form_fields
    common.fetch("form_fields", [])
  end

  def common_form_fields_objects
    common_form_fields.map do |field|
      obj = (Struct.new(:id, :type, :label, :validation, :default_value, :properties)).new
      obj.id = field["id"]
      obj.type = field["type"]
      obj.label = field["label"]
      obj.default_value = field["default_value"]
      obj.validation = ActiveSupport::HashWithIndifferentAccess.new(field.fetch("validation", {}))
      obj.properties = ActiveSupport::HashWithIndifferentAccess.new(field.fetch("properties", {}))
      obj
    end
  end

  def common_inputs_outputs
    common.fetch("inputs_outputs", {})
  end

  def common_inputs_outputs_input_parameters
    common_inputs_outputs.fetch("input_parameters", []).map{ |el| ActiveSupport::HashWithIndifferentAccess.new(el) }
  end

  def common_inputs_outputs_output_parameters
    common_inputs_outputs.fetch("output_parameters", []).map{ |el| ActiveSupport::HashWithIndifferentAccess.new(el) }
  end

  def common_task_listeners
    common.fetch("task_listeners", []).map{ |el| ActiveSupport::HashWithIndifferentAccess.new(el) }
  end

  def common_execution_listeners
    common.fetch("execution_listeners", []).map{ |el| ActiveSupport::HashWithIndifferentAccess.new(el) }
  end

  def gateway_default_flow
    extension["default_flow"]
  end

  def start_event_initiator
    extension["initiator"]
  end

  def user_task_assignee
    extension["assignee"]
  end

  def user_task_candidate_users
    extension["candidate_users"]
  end

  def user_task_candidate_groups
    extension["candidate_groups"]
  end

end
