module HydraEditor
  class Engine < ::Rails::Engine
    engine_name 'hydra_editor'
    config.autoload_paths += %W(
       #{config.root}/app/helpers/concerns
       #{config.root}/app/controllers/concerns
       #{config.root}/app/models/concerns
    )
  end
end
