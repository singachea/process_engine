class ProcessEngine::ProcessDefinitionsController < ProcessEngine::ApplicationController
  before_action :set_definition, only: [:bpmn_xml, :show, :edit, :update, :destroy, :start_new_process_instance]

  def index
    @definitions = ProcessEngine::ProcessDefinition.page(params[:page]).per_page(20)
  end

  def show
  end

  def new
    @definition = ProcessEngine::ProcessDefinition.new
  end

  def create
    @definition = ProcessEngine::ProcessDefinition.new

    if update_active_record_complex_type(@definition) do
        @definition.assign_attributes definition_params
        @definition.save
      end

      redirect_to process_definition_path(@definition)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if update_active_record_complex_type(@definition) { @definition.update definition_params }
      redirect_to process_definition_path(@definition)
    else
      render :edit
    end
  end

  def destroy
    @definition.destroy
    redirect_to process_definitions_path
  end

  def start_new_process_instance
    pi = ProcessEngine::ProcessQuery.process_instance_start(@definition.slug, "dummy")
    redirect_to process_instance_path(pi)
  end

  def bpmn_xml
    render text: @definition.bpmn_xml, content_type: 'text/xml'
  end

  private

  def set_definition
    @definition = ProcessEngine::ProcessDefinition.find(params[:id])
  end

  def definition_params
    params.require(:process_definition).permit(:name, :slug, :description, :bpmn_xml)
  end
end
