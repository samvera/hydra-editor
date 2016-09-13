require 'spec_helper'

describe 'MultiValueInput', type: :input do
  class Foo < ActiveFedora::Base
    property :bar, predicate: ::RDF::URI('http://example.com/bar')
  end

  context 'happy case' do
    let(:foo) { Foo.new }
    let(:bar) { ['bar1', 'bar2'] }
    subject do
      foo.bar = bar
      input_for(foo, :bar, as: :multi_value, required: true)
    end

    it 'renders multi-value' do
      expect(subject).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: '* Bar')
      expect(subject).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar', count: 3)
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
      expect(subject).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: '* Bar')
      expect(subject).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar')
    end
  end

  describe '#build_field' do
    let(:foo) { Foo.new }
    before { foo.bar = ['bar1', 'bar2'] }
    let(:builder) { double('builder', object: foo, object_name: 'foo') }

    subject { MultiValueInput.new(builder, :bar, nil, :multi_value, {}) }

    it 'renders multi-value' do
      expect(subject).to receive(:build_field).with('bar1', Fixnum)
      expect(subject).to receive(:build_field).with('bar2', Fixnum)
      expect(subject).to receive(:build_field).with('', 2)
      subject.input({})
    end
  end
end
