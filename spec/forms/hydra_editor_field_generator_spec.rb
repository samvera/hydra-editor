require 'spec_helper'

describe HydraEditor::Fields::Generator do
  subject { HydraEditor::Fields::Generator }

  describe ".new" do
    let(:factory) { class_double("HydraEditor::Fields::Factory") }
    let(:key) { :key }
    let(:form) { double("form") }
    let(:object) { double("form.object") }
    let(:field) { double("field") }

    it "builds a field using its factory" do
      expect(subject).to receive(:factory).and_return(factory)
      expect(form).to receive(:object).and_return(object)
      expect(factory).to receive(:create).with(object, key).and_return(field)

      generator = subject.new(form, key)
      expect(generator.field).to eq(field)
    end
  end

  describe ".factory" do
    subject { HydraEditor::Fields::Generator.factory }
    it { is_expected.to eq(HydraEditor::Fields::Factory) }
  end
end
