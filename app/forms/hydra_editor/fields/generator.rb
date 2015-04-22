module HydraEditor
  module Fields
    class Generator
      class << self
        attr_writer :factory

        def factory
          @factory ||= HydraEditor::Fields::Factory
        end
      end

      attr_reader :form, :field
      attr_writer :factory

      def initialize(form, key)
        @form = form
        @field = factory.create(form.object, key)
      end

      def factory
        @factory ||= self.class.factory
      end

      def input
        form.input field.property, field.options
      end
    end
  end
end
