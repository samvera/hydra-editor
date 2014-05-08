require 'spec_helper'

describe "routes to the records controller" do

  routes { HydraEditor::Engine.routes }

  before do
    @audio = Audio.new(pid: 'test:7.a-b')
    @audio.stub(:persisted?).and_return(true)
    @audio.stub(:save).and_return(true)
  end

  it "should handle pids with hyphens" do
    expect(:get => edit_record_path(@audio)).
        to route_to(:controller => "records", :action => "edit", :id => "test:7.a-b")
  end
end
