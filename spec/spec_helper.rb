ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!
# Load support files

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include HydraEditor::Engine.routes.url_helpers
  # see https://github.com/rails/journey/issues/39
  config.before(:each, :type=>"controller") { @routes = HydraEditor::Engine.routes }

  config.include Warden::Test::Helpers
end
