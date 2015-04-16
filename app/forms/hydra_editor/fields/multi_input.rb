module HydraEditor
  module Fields
    class MultiInput  < Input
      def initialize(object, property)
        super

        @field_type = :multi_value
        @input_html_options = { class: "form-control" }
        @wrapper_html_options = { class: "repeating-field" }
      end
    end
  end
end
