source "https://rubygems.org"

# Declare your gem's dependencies in hydra-editor.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec path: File.expand_path('..', __FILE__)

gem 'slop', '~> 3.6.0' # This just helps us generate a valid Gemfile.lock when Rails 4.2 is installed (which requires byebug which has a dependency on slop)

file = File.expand_path("Gemfile", ENV['ENGINE_CART_DESTINATION'] || ENV['RAILS_ROOT'] || File.expand_path("../spec/internal", __FILE__))
if File.exists?(file)
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(file)
else
  gem 'rails', ENV['RAILS_VERSION'] if ENV['RAILS_VERSION']

  if ENV['RAILS_VERSION'] and ENV['RAILS_VERSION'] !~ /^4.2/
    gem "bootstrap-sass", "3.3.4.1"
    gem 'sass-rails', "< 5.0"
  else
    gem 'responders', "~> 2.0"
    gem 'sass-rails', ">= 5.0"
  end
end
