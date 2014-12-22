require 'spec_helper'

describe Hydra::Presenter do
  class TestModel < ActiveFedora::Base
    property :title, predicate: ::RDF::DC.title
    property :creator, predicate: ::RDF::DC.creator, multiple: false
  end

  class TestPresenter
    include Hydra::Presenter
    self.model_class = TestModel
    # Terms is the list of fields displayed by app/views/generic_files/_show_descriptions.html.erb
    self.terms = [:title, :creator]

    # Depositor and permissions are not displayed in app/views/generic_files/_show_descriptions.html.erb
    # so don't include them in `terms'.
    delegate :depositor, :permissions, to: :model
  end

  describe "class methods" do
    subject { TestPresenter.model_name }
    it { is_expected.to eq 'TestModel' }
  end

  let(:object) { TestModel.new(title: ['foo', 'bar'], creator: 'baz') }
  let(:presenter) { TestPresenter.new(object) }

  describe "#terms" do
    subject { presenter.terms }
    it { is_expected.to eq [:title, :creator] }
  end

  describe "the term accessors" do
    it "should have the accessors" do
      expect(presenter.title).to eq ['foo', 'bar']
      expect(presenter.creator).to eq 'baz'
    end

    it "should have the hash accessors" do
      expect(presenter[:title]).to eq ['foo', 'bar']
      expect(presenter[:creator]).to eq 'baz'
    end
  end

end
