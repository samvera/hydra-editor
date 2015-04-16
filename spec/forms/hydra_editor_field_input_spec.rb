require 'spec_helper'

describe HydraEditor::Fields::Input do
  let(:input) { HydraEditor::Fields::Input.new(object, property) }
  let(:object) { double("form object") }
  let(:property) { :property }

  describe "#options" do
    subject { input.options }
    let(:required) { double("required") }

    before do
      allow(object).to receive(:required?).with(:property).and_return(required)
    end

    context "when fields are left as-is" do
      it { is_expected.to match(:required => required) }
    end

    context "when field_type is defined" do
      before do
        input.field_type = :foo
      end
      it { is_expected.to include(:as => :foo) }
    end

    context "when input_html_options is defined" do
      before do
        input.input_html_options = :bar
      end
      it { is_expected.to include(:input_html => :bar) }
    end

    context "when wrapper_html_options is defined" do
      before do
        input.wrapper_html_options = :bar
      end
      it { is_expected.to include(:wrapper_html => :bar) }
    end
  end
end
