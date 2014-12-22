require "hydra_editor/engine"
require "bootstrap_form"

module HydraEditor

  class InvalidType < RuntimeError; end

  extend ActiveSupport::Autoload

  autoload :ControllerResource

  def self.models= val
    @models = val
  end

  def self.models
    @models ||= []
  end

  def self.valid_model?(type)
    models.include? type
  end

  def self.Presenter(generic)
    self.const_set("#{generic}Form", Class.new(Hydra::Presenter)).tap do |klass|
      klass.model_class = generic
    end
  end
end
