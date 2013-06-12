require "hydra_editor/engine"
require "bootstrap_forms"

module HydraEditor
  def self.models= val
    @models = val
  end

  def self.models
    @models ||= []
  end
end
