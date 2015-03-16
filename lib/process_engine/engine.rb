module ProcessEngine
  class Engine < ::Rails::Engine
    isolate_namespace ProcessEngine

    config.after_initialize do
      # check after initialization to make sure that the implemented
      # specs are are in accordance with required methods
      ProcessEngine::NodeDataInjection.implementation_check
    end

  end
end
