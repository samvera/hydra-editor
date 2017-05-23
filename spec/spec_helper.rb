ENV['RAILS_ENV'] ||= 'test'
require 'devise'

require 'engine_cart'
EngineCart.load_application!

require 'rails-controller-testing'
require 'rspec/rails'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!
# Load support files

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  if defined? Devise::Test::ControllerHelpers
    config.include Devise::Test::ControllerHelpers, type: :controller
  else
    config.include Devise::TestHelpers, type: :controller
  end

  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  # see https://github.com/rails/journey/issues/39
  config.before(:each, type: 'controller') { @routes = HydraEditor::Engine.routes }

  config.include Warden::Test::Helpers

  config.include InputSupport, type: :input
  config.include Capybara::RSpecMatchers, type: :input

  config.include ControllerLevelHelpers, type: :view
  config.before(:each, type: :view) { initialize_controller_helpers(view) }

  if Rails::VERSION::MAJOR >= 5
    config.include ::Rails.application.routes.url_helpers
    config.include ::Rails.application.routes.mounted_helpers
  end

  config.infer_spec_type_from_file_location!
end
