module HydraEditor
  class Engine < ::Rails::Engine
    engine_name 'hydra_editor'
    config.eager_load_paths += %W(
       #{config.root}/app/helpers/concerns
       #{config.root}/app/presenters
    )
    initializer 'hydra-editor.initialize' do
      require 'cancan'
    end
  end
end
