require "spec_helper"
require 'hydra_editor/spec/resource'

describe HydraEditor do
  it "has a version number" do
    expect(HydraEditor::VERSION).not_to be nil
  end
  describe TestModel do
    let(:resource) do
      TestModel.new(
        title: ["foo", "bar"],
        creator: "baz"
      )
    end
    it_behaves_like "a Hydra::Editor compatible resource"
  end
end
