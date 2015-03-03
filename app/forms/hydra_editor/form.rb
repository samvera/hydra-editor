module HydraEditor
  module Form
    extend ActiveSupport::Autoload
    autoload :Permissions
    extend ActiveSupport::Concern

    include Hydra::Presenter
    included do
      class_attribute :required_fields
      self.required_fields = []
      delegate :errors, to: :model
    end

    def initialize(model)
      super
      initialize_fields
    end

    def required?(key)
      required_fields.include?(key)
    end

    def [](key)
      @attributes[key.to_s]
    end

    def []=(key, value)
      @attributes[key.to_s] = value
    end

    class Validator < ActiveModel::Validations::PresenceValidator
      def self.kind
        :presence
      end
    end

    module ClassMethods
      def validators_on(*attributes)
        attributes.flat_map do |attribute|
          if required_fields.include?(attribute)
            [Validator.new(attributes: [attribute])]
          else
            []
          end
        end
      end

      def model_attributes(form_params)
        clean_params = sanitize_params(form_params)
        terms.each do |key|
          clean_params[key].delete('') if clean_params[key]
          clean_params[key] = nil if clean_params[key] == ""
        end
        clean_params
      end

      def sanitize_params(form_params)
        form_params.permit(*permitted_params)
      end

      def permitted_params
        @permitted ||= build_permitted_params
      end

      def build_permitted_params
        permitted = []
        terms.each do |term|
          if multiple?(term)
            permitted << { term => [] }
          else
            permitted << term
          end
        end
        permitted
      end
    end

    protected
      def initialize_fields
        # we're making a local copy of the attributes that we can modify.
        @attributes = model.attributes
        terms.select { |key| self[key].blank? }.each { |key| initialize_field(key) }
      end

      # override this method if you need to initialize more complex RDF assertions (b-nodes)
      def initialize_field(key)
        # if value is empty, we create an one element array to loop over for output
        if self.class.multiple?(key)
          self[key] = ['']
        else
          self[key] = ''
        end
      end
  end
end
