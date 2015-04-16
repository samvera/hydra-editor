require 'spec_helper'

describe HydraEditor::Fields::Factory do
  subject { HydraEditor::Fields::Factory.create(object, property) }
  let(:object) { double("form object") }
  let(:object_class) { double("form object class") }
  let(:property) { :property }

  before do
    allow(object).to receive(:class).and_return(object_class)
    allow(object_class).to receive(:multiple?).with(property).and_return(multiple)
  end

  describe ".create" do
    context "when multiple is true" do
      let(:multiple) { true }
      it { is_expected.to be_instance_of(HydraEditor::Fields::MultiInput) }
    end

    context "when multiple is false" do
      let(:multiple) { false }
      it { is_expected.to be_instance_of(HydraEditor::Fields::Input) }
    end
  end
end
