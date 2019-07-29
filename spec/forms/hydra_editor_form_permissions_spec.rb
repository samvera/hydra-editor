require 'spec_helper'

describe HydraEditor::Form::Permissions do
  before do
    class TestModel < ActiveFedora::Base
      property :title, predicate: ::RDF::Vocab::DC.title
      property :creator, predicate: ::RDF::Vocab::DC.creator, multiple: false
    end

    class TestForm
      include HydraEditor::Form
      include HydraEditor::Form::Permissions
      self.model_class = TestModel
      # Terms is the list of fields displayed by app/views/records/_form.html.erb
      self.terms = [:title, :creator]
    end
  end

  after do
    Object.send(:remove_const, :TestForm)
    Object.send(:remove_const, :TestModel)
  end

  describe 'model_attributes' do
    subject(:permissions) { TestForm.model_attributes(params) }
    let(:params) { ActionController::Parameters.new(title: [''], creator: 'bob', description: ['huh'], permissions_attributes: { '0' => { id: '123', _destroy: 'true' } }) }

    it { is_expected.to eq('creator' => 'bob', 'title' => [],
                           'permissions_attributes' => { '0' => { 'id' => '123', '_destroy' => 'true' } }) }
  end

  describe 'permissions_attributes=' do
    subject(:form) { TestForm.new(TestModel.new) }
    it 'responds to permissions_attributes=' do
      expect(form).to respond_to(:permissions_attributes=)
    end
  end
end
