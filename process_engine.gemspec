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
  s.add_dependency "will_paginate"
  s.add_dependency "haml-rails"
  s.add_dependency "simple_form"
  s.add_dependency "bower-rails"
  s.add_dependency "nokogiri"
  s.add_dependency "pg"
  s.add_dependency "rails-assets-bootstrap"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "hirb"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "quiet_assets"
  s.add_development_dependency "pry"
end
