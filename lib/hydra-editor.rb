require "hydra_editor/engine"

module HydraEditor
  def self.models= val
    @models = val
  end

  def self.models
    @models ||= []
  end
end
