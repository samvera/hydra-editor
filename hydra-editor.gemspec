$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hydra_editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hydra-editor"
  s.version     = HydraEditor::VERSION
  s.authors     = ["Justin Coyne", "David Chandek-Stark", "Thomas Johnson"]
  s.email       = ["samvera-tech@googlegroups.com"]
  s.homepage    = "http://github.com/samvera/hydra-editor"
  s.summary     = "A basic metadata editor for hydra-head"
  s.description = "A basic metadata editor for hydra-head"
  s.metadata    = { "rubygems_mfa_required" => "true" }

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md", "History.md"]

  s.add_dependency "activerecord", ">= 5.2", "< 8.0"
  s.add_dependency "active-fedora", ">= 9.0.0"
  s.add_dependency "almond-rails", '~> 0.1'
  s.add_dependency "cancancan"
  s.add_dependency "psych", "~> 3.3", "< 4"
  s.add_dependency "rails", ">= 5.2", "< 8.0"
  s.add_dependency "simple_form", '>= 4.1.0', '< 5.2'
  s.add_dependency 'sprockets', '>= 3.7'
  s.add_dependency 'sprockets-es6'
  s.add_dependency 'concurrent-ruby', '1.3.4' # Pinned until Rails 7 update

  s.add_development_dependency "bixby"
  s.add_development_dependency "capybara", '~> 2.4'
  s.add_development_dependency "devise", '~> 4.0'
  s.add_development_dependency "engine_cart", '~> 2.2'
  s.add_development_dependency 'factory_bot_rails', '~> 4.8'
  s.add_development_dependency 'fcrepo_wrapper'
  s.add_development_dependency "hydra-head", '>= 10.5'
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rspec-rails', '>= 4'
  s.add_development_dependency 'sdoc', '~> 1.0'
  s.add_development_dependency 'simplecov', '~> 0.16'
  s.add_development_dependency 'solr_wrapper'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
