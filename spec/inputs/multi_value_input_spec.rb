require 'spec_helper'

describe 'MultiValueInput', type: :input do
  class Foo < ActiveFedora::Base
    property :bar, predicate: ::RDF::URI('http://example.com/bar')

    def double_bar
      bar.map { |b| b+ b }
    end
  end

  context 'happy case' do
    let(:foo) do
      Foo.new.tap { |f| f.bar = bar }
    end
    let(:bar) { ['bar1', 'bar2'] }

    context "for values from a property on the object" do
      subject { input_for(foo, :bar, as: :multi_value, required: true) }

      it 'renders multi-value' do

        # For handling older releases of SimpleForm
        expect(subject).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: /(\*\s)?Bar(\s\*)?/)
        expect(subject).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar', count: 3)
      end
    end

    context 'for values from a method on the object' do
      subject { input_for(foo, :double_bar, as: :multi_value) }

      # For handling older releases of SimpleForm
      it 'renders multi-value' do
        expect(subject).to have_selector('.form-group.foo_double_bar.multi_value ul.listing li input.foo_double_bar', count: 3)
      end
    end
  end

  context 'unhappy case' do
    let(:foo) { Foo.new }
    let(:bar) { nil }
    subject do
      foo.bar = bar
      input_for(foo, :bar, as: :multi_value, required: true)
    end

    it 'renders multi-value given a nil object' do
      expect(subject).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: /(\*\s)?Bar(\s\*)?/)
      expect(subject).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar')
    end
  end

  describe '#build_field' do
    let(:foo) { Foo.new }
    before { foo.bar = ['bar1', 'bar2'] }
    let(:builder) { double('builder', object: foo, object_name: 'foo') }

    subject { MultiValueInput.new(builder, :bar, nil, :multi_value, {}) }

    it 'renders multi-value' do
      expect(subject).to receive(:build_field).with('bar1', Integer)
      expect(subject).to receive(:build_field).with('bar2', Integer)
      expect(subject).to receive(:build_field).with('', 2)
      subject.input({})
    end
  end
end
