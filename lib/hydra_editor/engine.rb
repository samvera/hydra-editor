module HydraEditor
  class Engine < ::Rails::Engine
    engine_name 'hydra_editor'
    config.paths.add "app/helpers/concerns",      eager_load: true
    config.paths.add "app/controllers/concerns",  eager_load: true
    config.paths.add "app/models/concerns",       eager_load: true
  end
end
