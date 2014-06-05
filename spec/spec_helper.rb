ENV['RAILS_ENV'] ||= 'test'
require 'devise'

require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!
# Load support files

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  # see https://github.com/rails/journey/issues/39
  config.before(:each, :type=>"controller") { @routes = HydraEditor::Engine.routes }

  config.include Warden::Test::Helpers
  config.infer_spec_type_from_file_location!
end
