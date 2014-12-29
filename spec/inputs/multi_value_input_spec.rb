require 'spec_helper'

describe 'MultiValueInput', type: :input do

  class Foo
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    def persisted?; false; end
    attr_accessor :bar

    def [](val)
      raise "Unknown attribute" unless val == :bar
      bar
    end
  end

  context 'happy case' do
    let(:foo) { Foo.new }
    let(:bar) { ["bar1", "bar2"] }
    subject do
      foo.bar = bar
      input_for(foo, :bar, { as: :multi_value, required: true } )
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
      input_for(foo, :bar, { as: :multi_value, required: true } )
    end


    it 'renders multi-value given a nil object' do
      expect(subject).to have_selector('.form-group.foo_bar.multi_value label.required[for=foo_bar]', text: '* Bar')
      expect(subject).to have_selector('.form-group.foo_bar.multi_value ul.listing li input.foo_bar')
    end
  end
end
