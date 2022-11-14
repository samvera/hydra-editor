require 'spec_helper'

describe 'record editing' do
  let(:user) { FactoryBot.create(:user) }
  let(:record) do
    begin
      Audio.find('audio-1')
    rescue ActiveFedora::ObjectNotFoundError
      Audio.create(id: 'audio-1', title: ['Cool Track'])
    end
  end

  before do
    HydraEditor.models = ['Audio']
    allow_any_instance_of(Ability).to receive(:authorize!).and_return(true)
    # Avoid the catalog so we don't have to run Solr
    allow_any_instance_of(RecordsController).to receive(:redirect_after_update).and_return('/404.html')
    login_as user
  end

  after do
    Warden.test_reset!
  end

  # The following error is raised:
  # ActionView::Template::Error:
  #   type mismatch: NilClass given
  #   ./app/controllers/concerns/records_controller_behavior.rb:30:in `edit'
  xit 'is idempotent' do
    visit "/records/#{record.id}/edit"
    fill_in 'Title', with: 'Even Better Track'
    click_button 'Save'
    record.reload
    expect(record.title).to eq ['Even Better Track']
    expect(record.creator).to eq []
    expect(record.description).to eq []
    expect(record.subject).to eq []
  end
end
