require 'spec_helper'

describe MultiValueInput, type: :input do
  class TestInput < TestModel
    def double_bar
      title.map { |b| b + b }
    end
  end

  context 'when provided an Array for an attribute' do
    let(:test_instance) do
      TestInput.new.tap { |f| f.title = bar }
    end
    let(:bar) { ['bar1', 'bar2'] }

    context "for values from a property on the object" do
      subject(:multi_value_input) { input_for(test_instance, :title, as: :multi_value, required: true) }

      it 'renders multi-value' do
        # For handling older releases of SimpleForm
        expect(multi_value_input).to have_selector('.form-group.test_input_title.multi_value label.required[for=test_input_title]', text: /(\*\s)?Title(\s\*)?/)
        expect(multi_value_input).to have_selector('.form-group.test_input_title.multi_value ul.listing li input.test_input_title', count: 3)
      end
    end

    context 'for values from a method on the object' do
      subject(:multi_value_input) { input_for(test_instance, :double_bar, as: :multi_value) }

      # For handling older releases of SimpleForm
      it 'renders multi-value' do
        expect(multi_value_input).to have_selector('.form-group.test_input_double_bar.multi_value ul.listing li input.test_input_double_bar', count: 3)
      end
    end
  end

  context 'when provided a nil value for an attribute' do
    subject(:multi_value_input) do
      test_instance.title = bar
      input_for(test_instance, :title, as: :multi_value, required: true)
    end
    let(:test_instance) { TestInput.new }
    let(:bar) { [] }

    it 'renders multi-value given an empty array' do
      expect(multi_value_input).to have_selector('.form-group.test_input_title.multi_value label.required[for=test_input_title]', text: /(\*\s)?Title(\s\*)?/)
      expect(multi_value_input).to have_selector('.form-group.test_input_title.multi_value ul.listing li input.test_input_title')
    end
  end

  describe '#build_field' do
    let(:multi_value_input) { described_class.new(builder, :title, nil, :multi_value, {}) }
    let(:test_instance) { TestInput.new }
    let(:builder) { double('builder', object: test_instance, object_name: 'foo') }
    before do
      allow(builder).to receive(:text_field)
      allow(multi_value_input).to receive(:build_field)
      test_instance.title = ['bar1', 'bar2']
    end

    it 'renders multi-value' do
      multi_value_input.input({})
      expect(multi_value_input).to have_received(:build_field).with('bar1', Integer)
      expect(multi_value_input).to have_received(:build_field).with('bar2', Integer)
      expect(multi_value_input).to have_received(:build_field).with('', 2)
    end
  end
end
