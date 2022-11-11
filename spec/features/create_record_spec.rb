require 'spec_helper'

feature 'User creates an object' do
  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    ActionController::Parameters.new(
      'title' => ['My title'], 'creator' => [], 'description' => [], 'subject' => [], 'isPartOf' => []
    )
  end

  before do
    HydraEditor.models = ['Audio']
    params.permit!
    login_as user
    # since we're stubbing save, we won't have an id to redirect to.
    allow_any_instance_of(RecordsController).to receive(:redirect_after_create).and_return('/404.html')
  end

  context 'with a TuftsAudio' do
    # The following error is raised:
    #
    # ActionView::Template::Error:
    #   type mismatch: NilClass given
    #   ./app/controllers/concerns/records_controller_behavior.rb:9:in `block (2 levels) in <module:RecordsControllerBehavior>'
    #   ./spec/features/create_record_spec.rb:20:in `block (2 levels) in <top (required)>'
    xit 'persists the Work' do
      visit '/records/new'

      select 'Audio', from: 'Select an object type'
      click_button 'Next'

      fill_in 'Title', with: 'My audio work at Tufts'
      click_button 'Save'

      audio_work = Audio.all.to_a.find { |audio| audio.title.include?('My audio work at Tufts') }
      expect(audio_work).not_to be nil
    end
  end
end
