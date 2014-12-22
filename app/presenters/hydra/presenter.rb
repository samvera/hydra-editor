module Hydra
  module ActiveModelPresenter
    extend ActiveSupport::Concern
    included do
      attr_reader :model
      class_attribute :model_class
    end

    def initialize(object)
      @model = object
    end

    def to_key
      model.to_key
    end

    def to_param
      model.to_param
    end

    def to_model
      model.to_model
    end

    def persisted?
      model.persisted?
    end

    def [](key)
      model[key]
    end

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

    module ClassMethods
      def multiple?(field)
        model_class.multiple?(field)
      end

      def unique?(field)
        model_class.unique?(field)
      end

      def terms=(terms)
        self._terms = terms
        create_term_accessors(terms)
      end

      def terms
        self._terms
      end

      private

        def create_term_accessors(terms)
          # we delegate to the array accessor, because the array accessor is overridden in MultiForm
          # which is included by GenericFileEditForm
          terms.each do |term|
            define_method term do
              self[term]
            end
          end
        end
    end
  end
end
