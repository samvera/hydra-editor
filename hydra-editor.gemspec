$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hydra_editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hydra-editor"
  s.version     = HydraEditor::VERSION
  s.authors     = ["Justin Coyne", "David Chandek-Stark"]
  s.email       = ["hydra-tech@googlegroups.com"]
  s.homepage    = "http://github.com/projecthydra/hydra-editor"
  s.summary     = "A basic metadata editor for hydra-head"
  s.description = "A basic metadata editor for hydra-head"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md", "History.md"]

  s.add_dependency "rails", ">= 3.2.13", "< 5.0"
  s.add_dependency 'bootstrap_form', '~> 2.1.1'
  s.add_dependency "active-fedora", ">= 6.3.0"
  s.add_dependency "cancancan"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "devise"
  s.add_development_dependency "hydra-head"
  s.add_development_dependency "engine_cart"
end
