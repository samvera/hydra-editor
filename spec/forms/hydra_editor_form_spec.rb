require 'spec_helper'

describe HydraEditor::Form do
  before do
    class TestForm
      include HydraEditor::Form
      self.model_class = TestModel
      # Terms is the list of fields displayed by app/views/records/_form.html.erb
      self.terms = [:title, :creator]
    end
  end

  after do
    Object.send(:remove_const, :TestForm)
  end

  describe 'class methods' do
    subject { TestForm.model_name }
    it { is_expected.to eq 'TestModel' }

    describe 'model_attributes' do
      subject { TestForm.model_attributes(params) }
      let(:params) { ActionController::Parameters.new(title: [''], creator: 'bob', description: ['huh']) }

      it { is_expected.to eq('creator' => 'bob', 'title' => []) }

      describe "setting non-multiple attribute to nil when value is empty string" do
        let(:params) { ActionController::Parameters.new(title: [''], creator: '') }
        it { is_expected.to eq('creator' => nil, 'title' => []) }
      end
    end
  end

  let(:object) { TestModel.new(title: ['foo', 'bar'], creator: 'baz') }
  let(:form) { TestForm.new(object) }

  describe '#terms' do
    subject { form.terms }
    it { is_expected.to eq [:title, :creator] }
  end

  describe 'the term accessors' do
    it 'has the accessors' do
      expect(form.title).to match_array ['foo', 'bar']
      expect(form.creator).to eq 'baz'
    end

    it 'has the hash accessors' do
      expect(form[:title]).to match_array ['foo', 'bar']
      expect(form[:creator]).to eq 'baz'
    end
  end

  describe '#initialize_field' do
    before do
      form[:title] = nil
    end

    it 'puts an empty element in the value' do
      expect { form.send(:initialize_field, :title) }.to change { form[:title] }.
        from(nil).to([''])
    end
  end

  describe '#errors' do
    let(:errors) { double(:errors) }
    before do
      allow(object).to receive(:errors).and_return(errors)
    end
    it 'delegates to model' do
      expect(form.errors).to eq errors
    end
  end

  describe '.validators_on' do
    context 'with required fields' do
      before do
        TestForm.required_fields = [:title]
      end
      it 'creates them for required fields' do
        expect(TestForm.validators_on(:title).first).to be_instance_of HydraEditor::Form::Validator
        expect(TestForm.validators_on(:title).first.options).to eq({})
        expect(TestForm.validators_on(:title).first.kind).to eq :presence
      end
    end
    context 'without required fields' do
      it 'creates them for required fields' do
        expect(TestForm.validators_on(:title)).to eq []
      end
    end
  end

  describe ".field_metadata_service" do
    before do
      class CustomMetadataService
      end
    end

    after do
      Object.send(:remove_const, :CustomMetadataService)
    end

    it "is settable" do
      expect { TestForm.field_metadata_service = CustomMetadataService }.to change { TestForm.field_metadata_service }
        .from(HydraEditor::FieldMetadataService)
        .to(CustomMetadataService)
    end
  end
end
