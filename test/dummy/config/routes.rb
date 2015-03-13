Rails.application.routes.draw do

  mount ProcessEngine::Engine => "/process_engine"
end
