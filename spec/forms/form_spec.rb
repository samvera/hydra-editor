require 'spec_helper'

describe HydraEditor::Form do
  let(:audio) { Audio.new }
  let(:form) { AudioForm.new(audio) }
  
  describe "#errors" do
    let(:errors) { double(:errors) }
    before do
      allow(form.model).to receive(:errors).and_return(errors)
    end
    it "should delegate to model" do
      expect(form.errors).to eq errors
    end
  end
end
