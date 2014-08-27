require 'spec_helper'

describe 'records/_edit_field' do
  let(:audio) { Audio.new }
  let(:form) { BootstrapForm::FormBuilder.new(:foo, audio, view, {}) }

  before do
    allow(view).to receive(:f).and_return(form)
    allow(view).to receive(:key).and_return(:title)
  end

  context "when there are no errors" do
    it "should not have the error class" do
      render
      expect(response).to have_selector ".form-group"
      expect(response).to_not have_selector ".has-error"
    end
  end

  context "when errors are present" do
    before { allow(audio).to receive(:errors).and_return(title: ["can't be blank"]) }

    it "should have the error class" do
      render
      expect(response).to have_selector ".form-group.has-error"
      expect(response).to have_selector ".help-block", text: "can't be blank"
    end
  end
end


