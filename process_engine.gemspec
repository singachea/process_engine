$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "process_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "process_engine"
  s.version     = ProcessEngine::VERSION
  s.authors     = ["Ream"]
  s.email       = ["singachea@gmail.com"]
  s.homepage    = "http://2359media.com"
  s.summary     = "BPMN Engine"
  s.description = "BPMN Engine for Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "will_paginate", "~> 3.0.7"
  s.add_dependency "haml-rails", "~> 0.9.0"
  s.add_dependency "simple_form", "~> 3.1.0"
  s.add_dependency "nokogiri", "~> 1.6.6.0"
  s.add_dependency "pg", "~> 0.18.1"
  s.add_dependency "rails-assets-bootstrap", "~> 3.3.2"
  s.add_dependency "jquery-rails", "~> 4.0.3"

  s.add_development_dependency "hirb"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "quiet_assets"
  s.add_development_dependency "pry"
end
