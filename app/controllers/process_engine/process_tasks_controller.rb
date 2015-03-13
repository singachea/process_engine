class ProcessEngine::ProcessTasksController < ProcessEngine::ApplicationController
  before_action :set_process_instance, only: [:index]
  before_action :set_process_task, only: [:finish, :show, :edit, :update, :destroy]

  def index
    @process_tasks = @process_instance.process_tasks.desc.page(params[:page]).per_page(50)
  end

  def finish  
    ProcessEngine::ProcessQuery.task_complete(@process_task.id) unless @process_task.finished?
    redirect_to process_engine_process_instance_process_tasks_path(@process_task.process_instance_id)
  end

  # def show
  # end
  #
  # def edit
  # end
  #
  # def update
  #   if @process_instance.update(process_instance_params)
  #     redirect_to process_engine_process_instance_path(@process_instance)
  #   else
  #     render :edit
  #   end
  # end
  #
  # def destroy
  #   definition_id = @process_instance.process_definition_id
  #   @process_instance.destroy
  #   redirect_to process_engine_process_definition_path(definition_id)
  # end

  private

  # def process_instance_params
  #   params.require(:process_engine_process_instance).permit(:status, :state, :creator)
  # end
  #
  def set_process_task
    @process_task = ProcessEngine::ProcessTask.find(params[:id])
  end

  def set_process_instance
    @process_instance = ProcessEngine::ProcessInstance.find(params[:process_instance_id])
  end
end
