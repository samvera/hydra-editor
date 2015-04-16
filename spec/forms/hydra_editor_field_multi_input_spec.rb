require 'spec_helper'

describe HydraEditor::Fields::MultiInput do
  let(:input) { HydraEditor::Fields::MultiInput.new(object, property) }
  let(:object) { double("form object") }
  let(:property) { :property }

  describe "#options" do
    subject { input.options }
    let(:required) { double("required") }

    before do
      allow(object).to receive(:required?).with(:property).and_return(required)
    end

    it { is_expected.to match(:required => required, :as => :multi_value,
                              :input_html => { class: "form-control" },
                              :wrapper_html => { class: "repeating-field" }) }
  end
end
