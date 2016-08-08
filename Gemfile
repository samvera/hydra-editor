source "https://rubygems.org"

# Declare your gem's dependencies in hydra-editor.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec path: File.expand_path('..', __FILE__)

gem 'slop', '~> 3.6.0' # This just helps us generate a valid Gemfile.lock when Rails 4.2 is installed (which requires byebug which has a dependency on slop)

# BEGIN ENGINE_CART BLOCK
# engine_cart: 0.10.0
# engine_cart stanza: 0.10.0
# the below comes from engine_cart, a gem used to test this Rails engine gem in the context of a Rails app.
file = File.expand_path('Gemfile', ENV['ENGINE_CART_DESTINATION'] || ENV['RAILS_ROOT'] || File.expand_path('.internal_test_app', File.dirname(__FILE__)))
if File.exist?(file)
  begin
    eval_gemfile file
  rescue Bundler::GemfileError => e
    Bundler.ui.warn '[EngineCart] Skipping Rails application dependencies:'
    Bundler.ui.warn e.message
  end
else
  Bundler.ui.warn "[EngineCart] Unable to find test application dependencies in #{file}, using placeholder dependencies"

  if ENV['RAILS_VERSION']
    if ENV['RAILS_VERSION'] == 'edge'
      gem 'rails', github: 'rails/rails'
      ENV['ENGINE_CART_RAILS_OPTIONS'] = '--edge --skip-turbolinks'
    else
      gem 'rails', ENV['RAILS_VERSION']
    end
  end

  case ENV['RAILS_VERSION']
  when /^4.2/
    gem 'responders', '~> 2.0'
    gem 'sass-rails', '>= 5.0'
    gem 'coffee-rails', '~> 4.1.0'
  when /^4.[01]/
    gem 'sass-rails', '< 5.0'
  end
end
# END ENGINE_CART BLOCK

if !ENV['RAILS_VERSION'] || ENV['RAILS_VERSION'] =~ /^5.0/
  gem 'rails-controller-testing'
end
