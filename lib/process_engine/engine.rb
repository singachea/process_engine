module ProcessEngine
  class Engine < ::Rails::Engine
    isolate_namespace ProcessEngine

    # config.autoload_paths << File.expand_path("../api", __FILE__)

    config.after_initialize do
      # check after initialization to make sure that the implemented
      # specs are are in accordance with required methods
      ProcessEngine::NodeDataInjection.implementation_check
    end

    config.to_prepare do
      Dir.glob(File.expand_path("../api/**/*.rb", __FILE__)).each do |c|
        # require_dependency(c)
        require c
      end

    end

  end
end
