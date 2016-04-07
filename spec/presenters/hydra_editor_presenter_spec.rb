require 'spec_helper'

describe Hydra::Presenter do
  before do
    class TestModel < ActiveFedora::Base
      property :title, predicate: ::RDF::DC.title
      property :creator, predicate: ::RDF::DC.creator, multiple: false
      has_and_belongs_to_many :contributors, predicate: ::RDF::DC.contributor
      belongs_to :publisher, predicate: ::RDF::DC.publisher
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
  end

  after do
    Object.send(:remove_const, :TestPresenter)
    Object.send(:remove_const, :TestModel)
  end

  describe 'class methods' do
    subject { TestPresenter.model_name }
    it { is_expected.to eq 'TestModel' }
  end

  let(:object) { TestModel.new(title: ['foo', 'bar'], creator: 'baz') }
  let(:presenter) { TestPresenter.new(object) }

  describe '#terms' do
    subject { presenter.terms }
    it { is_expected.to eq [:title, :creator] }
  end

  describe 'new_record?' do
    subject { presenter.new_record? }
    it { is_expected.to be true }
  end

  describe 'persisted?' do
    subject { presenter.persisted? }
    it { is_expected.to be false }
  end

  describe 'the term accessors' do
    it 'has the accessors' do
      expect(presenter.title).to eq ['foo', 'bar']
      expect(presenter.creator).to eq 'baz'
    end

    it 'has the hash accessors' do
      expect(presenter[:title]).to eq ['foo', 'bar']
      expect(presenter[:creator]).to eq 'baz'
    end
  end

  context 'when a presenter has a method' do
    before do
      TestPresenter.class_eval do
        def count
          7
        end

        self.terms = [:count]
      end
    end

    it "isn't overridden by setting terms" do
      expect(presenter.count).to eq 7
    end
  end

  describe 'multiple?' do
    describe 'instance method' do
      subject { presenter.multiple?(field) }

      context 'for a multivalue string' do
        let(:field) { :title }
        it { is_expected.to be true }
      end

      context 'for a single value string' do
        let(:field) { :creator }
        it { is_expected.to be false }
      end

      context 'for a multivalue association' do
        let(:field) { :contributors }
        it { is_expected.to be true }
      end

      context 'for a single value association' do
        let(:field) { :publisher }
        it { is_expected.to be false }
      end

      context 'with anything else' do
        let(:field) { :visibility }
        it { is_expected.to be false }
      end
    end

    describe 'class method' do
      before { allow(Deprecation).to receive(:warn) }
      subject { TestPresenter.multiple?(field) }

      context 'for a multivalue string' do
        let(:field) { :title }
        it { is_expected.to be true }
      end

      context 'for a single value string' do
        let(:field) { :creator }
        it { is_expected.to be false }
      end

      context 'for a multivalue association' do
        let(:field) { :contributors }
        it { is_expected.to be true }
      end

      context 'for a single value association' do
        let(:field) { :publisher }
        it { is_expected.to be false }
      end
    end
  end

  describe 'unique?' do
    before { allow(Deprecation).to receive(:warn) }
    subject { TestPresenter.unique?(field) }

    context 'for a multivalue string' do
      let(:field) { :title }
      it { is_expected.to be false }
    end

    context 'for a single value string' do
      let(:field) { :creator }
      it { is_expected.to be true }
    end

    context 'for a multivalue association' do
      let(:field) { :contributors }
      it { is_expected.to be false }
    end

    context 'for a single value association' do
      let(:field) { :publisher }
      it { is_expected.to be true }
    end
  end
end
