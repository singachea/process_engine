ProcessEngine::Engine.routes.draw do
  # root "process_engine/process_definitions#index"


  root "process_definitions#index"
  
  resources :process_definitions, shallow: true do
    get :bpmn_xml, on: :member
    post :start_new_process_instance, on: :member

    resources :process_instances do
      resources :process_tasks do
        put :finish, on: :member
      end
    end
  end

end
