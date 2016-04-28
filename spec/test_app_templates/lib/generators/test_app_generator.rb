require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base

  def add_gems
    gem 'blacklight'
    gem 'hydra-head'
    Bundler.with_clean_env do
      run "bundle install"
    end
  end

  def run_simple_form_generator
    say_status("warning", "GENERATING BL", :yellow)
    generate "simple_form:install --bootstrap"
  end

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)
    generate "blacklight:install --devise"
    gsub_file "app/controllers/application_controller.rb", "layout 'blacklight'", "layout 'application'"
  end

  def run_hydra_generator
    say_status("warning", "GENERATING Hydra", :yellow)
    generate "hydra:head -f"
  end

  def run_migrations
    rake "db:migrate"
    rake "db:test:prepare"
  end

  def add_route
    insert_into_file "config/routes.rb", after: '.draw do' do
      "\n  mount HydraEditor::Engine => \"/\"\n"
    end
  end

  def inject_js
    insert_into_file 'app/assets/javascripts/application.js', after: '//= require_tree .' do
      <<-EOF.strip_heredoc

        //= require hydra-editor/hydra-editor
      EOF
    end
  end

  def add_create_ability
    # Required for hydra-head 7+
    insert_into_file "app/models/ability.rb", after: 'custom_permissions' do
      "\n    can :create, :all if user_groups.include? 'registered'\n"
    end

  end

end
