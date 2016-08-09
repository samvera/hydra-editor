module ControllerLevelHelpers
  def initialize_controller_helpers(helper)
    helper.extend ControllerLevelHelpers
    initialize_routing_helpers(helper)
  end

  def initialize_routing_helpers(helper)
    return unless Rails::VERSION::MAJOR >= 5

    helper.class.include ::Rails.application.routes.url_helpers
    helper.class.include ::Rails.application.routes.mounted_helpers if ::Rails.application.routes.respond_to?(:mounted_helpers)
  end
end
