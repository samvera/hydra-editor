require 'spec_helper'

describe 'records/_form' do
  let(:audio) { Audio.new }
  let(:form) { AudioForm.new(audio) }

  before do
    allow(view).to receive(:key).and_return(:title)
    allow(view).to receive(:form).and_return(form)
    allow(view).to receive(:main_app).and_return(Rails.application.routes.url_helpers)
  end

  context 'when there are no errors' do
    it 'does not have the error class' do
      render
      expect(response).to have_selector '.form-group'
      expect(response).not_to have_selector '.has-error'
    end
  end

  context 'when errors are present' do
    let(:errors) { instance_double(ActiveModel::Errors) }

    before do
      allow(errors).to receive(:[]).and_return(["can't be blank"])
      allow(errors).to receive(:full_messages_for).and_return(["can't be blank"])
      allow(form).to receive(:errors).and_return(errors)
    end

    it 'has the error class' do
      render
      expect(response).to have_selector '.form-group.form-group-invalid'
      expect(response).to have_selector '.invalid-feedback', text: "can't be blank"
    end
  end
end
