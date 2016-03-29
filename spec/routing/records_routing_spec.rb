require 'spec_helper'

describe 'routes to the records controller' do
  routes { HydraEditor::Engine.routes }

  let(:audio) { Audio.new(id: id) }
  before do
    allow(audio).to receive(:persisted?).and_return(true)
    allow(audio).to receive(:save).and_return(true)
  end

  context 'ids with hyphens' do
    let(:id) { 'test_7.a-b' }
    it 'routes them' do
      expect(get: edit_record_path(audio)).
          to route_to(controller: 'records', action: 'edit', id: 'test_7.a-b')
    end
  end

  context 'ids with percent' do
    let(:id) { 'test_7%2Fa-b' }
    it 'routes them' do
      expect(get: edit_record_path(audio)).
          to route_to(controller: 'records', action: 'edit', id: 'test_7/a-b')
    end
  end

  context 'ids with slash' do
    let(:id) { '16/2d/0a/8f/162d0a8f-49df-4fe1-9ee2-ea9357adcf88' }
    it 'routes them' do
      expect(get: edit_record_path(audio)).
          to route_to(controller: 'records', action: 'edit', id: '16/2d/0a/8f/162d0a8f-49df-4fe1-9ee2-ea9357adcf88')
    end
  end
end
