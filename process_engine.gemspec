$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "process_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "process_engine"
  s.version     = ProcessEngine::VERSION
  s.authors     = ["Ream"]
  s.email       = ["singachea@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ProcessEngine."
  s.description = "TODO: Description of ProcessEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "pg"
end
