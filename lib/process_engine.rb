Gem.loaded_specs['process_engine'].nondevelopment_dependencies.each do |d|
  require d.name
end

require "process_engine/engine"

module ProcessEngine
end
