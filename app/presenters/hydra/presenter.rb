module Hydra
  module ActiveModelPresenter
    extend ActiveSupport::Concern
    included do
      attr_reader :model

      # model_class only needs to be set if you are using the
      # deprecated class methods multiple? or unique? or if you
      # need to use +model_name+ method or if this class includes Hydra::Editor::Form.
      class_attribute :model_class
    end

    def initialize(object)
      @model = object
    end

    delegate :to_key, to: :model

    delegate :to_param, to: :model

    delegate :to_model, to: :model

    delegate :persisted?, to: :model

    delegate :[], to: :model

    module ClassMethods
      def model_name
        if model_class.nil?
          raise "You must set `self.model_class = ' after including Hydra::Presenter on #{self}."
        end
        model_class.model_name
      end
    end
  end

  module Presenter
    extend ActiveSupport::Concern
    include ActiveModelPresenter
    included do
      class_attribute :_terms, instance_accessor: false
    end

    def terms
      self.class._terms
    end

    # If the field is a reflection, delegate to the reflection.
    # If the field is a property, delegate to the property.
    # Otherwise return false
    def multiple?(field)
      HydraEditor::FieldMetadataService.multiple?(model.class, field)
    end

    module ClassMethods
      # @deprecated Because if we use an instance method, there will be no need to set self.model_class in most instances. Note, there is a class method multiple? on the form.
      def multiple?(field)
        Deprecation.warn(ClassMethods, 'The class method multiple? has been deprecated. Use the instance method instead. This will be removed in version 2.0')
        HydraEditor::FieldMetadataService.multiple?(model_class, field)
      end

      def unique?(field)
        Deprecation.warn(ClassMethods, "The class method unique? has been deprecated. Use the instance method 'multiple?' instead. This will be removed in version 2.0")
        if reflection = model_class.reflect_on_association(field)
          !reflection.collection?
        else
          model_class.unique?(field)
        end
      end

      def terms=(terms)
        self._terms = terms
        create_term_accessors(terms)
      end

      def terms
        _terms
      end

      private

        def create_term_accessors(terms)
          # we delegate to the array accessor, because the array accessor is overridden in MultiForm
          # which is included by GenericFileEditForm
          terms.each do |term|
            next if method_defined? term
            define_method term do
              self[term]
            end
          end
        end
    end
  end
end
