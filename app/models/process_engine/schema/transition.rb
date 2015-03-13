class ProcessEngine::Schema::Transition
  attr_reader :id, :type, :source, :target

  # available options
  # {
  #                     "name" => "sequence flow 3",
  #                  "node_id" => "sf3",
  #                "node_type" => "sequenceFlow",
  #               "source_ref" => "pg1",
  #               "target_ref" => "ut2",
  #       "extension_elements" => {},
  #     "condition_expression" => {}
  # }
  def initialize(options, _source, _target)

    @id = options[:node_id]
    @type = options[:node_type]
    @source = _source
    @target = _target
  end

end
