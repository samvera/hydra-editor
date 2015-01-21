require 'spec_helper'

describe HydraEditor::Form do
  before do
    class TestModel < ActiveFedora::Base
      property :title, predicate: ::RDF::DC.title
      property :creator, predicate: ::RDF::DC.creator, multiple: false
    end

    class TestForm
      include HydraEditor::Form
      self.model_class = TestModel
      # Terms is the list of fields displayed by app/views/records/_form.html.erb
      self.terms = [:title, :creator]
    end
  end

  after do
    Object.send(:remove_const, :TestForm)
    Object.send(:remove_const, :TestModel)
  end

  describe "class methods" do
    subject { TestForm.model_name }
    it { is_expected.to eq 'TestModel' }

    describe "model_attributes" do
      let(:params) { ActionController::Parameters.new(title: [''], creator: 'bob', description: ['huh']) }
      subject { TestForm.model_attributes(params) }

      it { is_expected.to eq('creator' => 'bob', 'title' => []) }
    end
  end

  let(:object) { TestModel.new(title: ['foo', 'bar'], creator: 'baz') }
  let(:form) { TestForm.new(object) }

  describe "#terms" do
    subject { form.terms }
    it { is_expected.to eq [:title, :creator] }
  end

  describe "the term accessors" do
    it "should have the accessors" do
      expect(form.title).to eq ['foo', 'bar']
      expect(form.creator).to eq 'baz'
    end

    it "should have the hash accessors" do
      expect(form[:title]).to eq ['foo', 'bar']
      expect(form[:creator]).to eq 'baz'
    end
  end

  describe "#initialize_field" do
    before do
      form[:title] = nil
    end

    it "should put an empty element in the value" do
      expect { form.send(:initialize_field, :title) }.to change { form[:title] }.
        from(nil).to([''])
    end
  end

end
