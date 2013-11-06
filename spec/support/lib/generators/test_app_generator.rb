require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base

  def add_routes
    insert_into_file "config/routes.rb", :after => '.draw do' do
      "\n  mount HydraEditor::Engine => \"/\""

    end
  end

  def add_secret_token
    inject_into_file "config/initializers/secret_token.rb", after: "# if you're sharing your code publicly.\n" do
      "Dummy::Application.config.secret_token = '#{SecureRandom.hex(64)}'\n"
    end
  end

  def fix_layout
    gsub_file "app/controllers/application_controller.rb", "layout 'blacklight'", "layout 'application'"
  end

end
