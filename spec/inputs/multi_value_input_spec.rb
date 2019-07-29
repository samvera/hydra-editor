require 'spec_helper'

describe MultiValueInput, type: :input do
  class Foo < ActiveFedora::Base
    property :bar, predicate: ::RDF::URI('http://example.com/bar')

    def double_bar
      bar.map { |b| b + b }
    end
  end

  context 'when provided an Array for an attribute' do
    let(:foo) do
      Foo.new.tap { |f| f.bar = bar }
    end
    let(:bar) { ['bar1', 'bar2'] }

    context "for values from a property on the object" do
      subject(:multi_value_input) { input_for(foo, :bar, as: :multi_value, required: true) }

      it 'renders multi-value' do
        # For handling older releases of SimpleForm
        expect(multi_value_input).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: /(\*\s)?Bar(\s\*)?/)
        expect(multi_value_input).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar', count: 3)
      end
    end

    context 'for values from a method on the object' do
      subject(:multi_value_input) { input_for(foo, :double_bar, as: :multi_value) }

      # For handling older releases of SimpleForm
      it 'renders multi-value' do
        expect(multi_value_input).to have_selector('.form-group.foo_double_bar.multi_value ul.listing li input.foo_double_bar', count: 3)
      end
    end
  end

  context 'when provided a nil value for an attribute' do
    subject(:multi_value_input) do
      foo.bar = bar
      input_for(foo, :bar, as: :multi_value, required: true)
    end
    let(:foo) { Foo.new }
    let(:bar) { nil }

    it 'renders multi-value given a nil object' do
      expect(multi_value_input).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: /(\*\s)?Bar(\s\*)?/)
      expect(multi_value_input).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar')
    end
  end

  describe '#build_field' do
    let(:multi_value_input) { described_class.new(builder, :bar, nil, :multi_value, {}) }
    let(:foo) { Foo.new }
    let(:builder) { double('builder', object: foo, object_name: 'foo') }
    before do
      allow(builder).to receive(:text_field)
      allow(multi_value_input).to receive(:build_field)
      foo.bar = ['bar1', 'bar2']
    end

    it 'renders multi-value' do
      multi_value_input.input({})
      expect(multi_value_input).to have_received(:build_field).with('bar1', Integer)
      expect(multi_value_input).to have_received(:build_field).with('bar2', Integer)
      expect(multi_value_input).to have_received(:build_field).with('', 2)
    end
  end
end
