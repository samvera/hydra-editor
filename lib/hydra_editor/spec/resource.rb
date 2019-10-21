# frozen_string_literal: true
RSpec.shared_examples 'a Hydra::Editor compatible resource' do
  before do
    raise 'resource must be set with `let(:resource)` which has a multi-value title and a single value creator' unless
      defined? resource
  end
  describe "#attributes" do
    it "returns a hash representation of its attributes" do
      expect(resource.attributes["title"]).to be_a Array
      expect(resource.attributes["title"].length > 1).to eq true
      expect(resource.attributes["creator"]).to be_a String
    end
  end

  describe ".reflect_on_association" do
    context "for a single valued field" do
      it "returns false for collection?" do
        expect(resource.class.reflect_on_association(:creator).collection?).to eq false
      end
    end
    context "for a multiple valued field" do
      it "returns true for collection?" do
        expect(resource.class.reflect_on_association(:title).collection?).to eq true
      end
    end
  end

  describe ".model_name" do
    it "returns a string version of the model's class" do
      expect(resource.class.model_name).to eq resource.class.to_s
    end
  end

  describe "#new_record?" do
    it "returns true" do
      expect(resource.new_record?).to eq true
    end
  end
end
