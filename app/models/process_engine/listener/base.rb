class ProcessEngine::Listener::Base
  attr_reader :process_task, :listener

  def initialize(process_task, listener)
    @process_task = process_task
    @listener = listener
  end

  def self.execute(process_task, listeners, event)
    listeners.select { |ln| ln[:event] == event}.each { |listener| new(process_task, listener).execute }
  end

  def execute
    listener_type = listener[:type]

    case listener_type
    when "class_name"
      execute_class_name
    when "delegate_expression"
      execute_delegate_expression
    when "expression"
      execute_expression
    when "script"
      execute_script
    else
      raise "No such type (#{listener_type}) supported"
    end
  end

  private

  def execute_class_name
    cls = (listener[:value]).constantize # let it raise error purposely, and user need to catch this
    cls.execute(process_task)
  end

  def execute_delegate_expression
    # need to implement
  end

  def execute_expression
    # need to implement
  end

  def execute_script
    # need to implement
  end

end
