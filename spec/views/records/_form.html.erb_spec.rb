require 'spec_helper'

describe 'records/_form' do
  let(:audio) { Audio.new }
  let(:form) { AudioForm.new(audio) }

  before do
    allow(view).to receive(:key).and_return(:title)
    allow(view).to receive(:form).and_return(form)
  end

  context "when there are no errors" do
    it "should not have the error class" do
      render
      expect(response).to have_selector ".form-group"
      expect(response).to_not have_selector ".has-error"
    end
  end

  context "when errors are present" do
    let(:errors) { double("errors", :[] => ["can't be blank"]) }
    before { allow(form).to receive(:errors).and_return(errors) }

    it "should have the error class" do
      render
      expect(response).to have_selector ".form-group.has-error"
      expect(response).to have_selector ".help-block", text: "can't be blank"
    end
  end
end


