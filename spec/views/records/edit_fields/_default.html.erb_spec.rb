require 'spec_helper'

describe 'records/edit_fields/_default' do
  let(:form) { SimpleForm::FormBuilder.new(:foo, audio_form, view, {}) }
  let(:audio_form) { AudioForm.new(audio) }
  let(:audio) { Audio.new }

  before do
    allow(view).to receive(:index).and_return(0)
    allow(view).to receive(:render_req).and_return(true)
    allow(view).to receive(:f).and_return(form)
    allow(view).to receive(:key).and_return(:title)
    allow(view).to receive(:v).and_return('')
  end

  context 'when the field is multivalued' do
    it 'has the input-group class and the add another button' do
      render
      expect(response).to have_selector '.multi_value'
    end
  end

  context 'when the field is not multivalued' do
    before { allow(Audio).to receive(:multiple?).with(:title).and_return(false) }

    it 'does not have the input-group class or the add another button' do
      render
      expect(response).not_to have_selector '.multi_value'
    end
  end
end
