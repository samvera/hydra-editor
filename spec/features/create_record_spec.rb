require 'spec_helper'

feature 'User creates an object' do
  let(:user) { FactoryGirl.create(:user) }
  let(:params) {
    ActionController::Parameters.new(
      'title' => ['My title'], 'creator' => [], 'description' => [], 'subject' => [], 'isPartOf' => []
    )
  }

  before do
    HydraEditor.models = ['Audio']
    params.permit!
    login_as user
    # since we're stubbing save, we won't have an id to redirect to.
    allow_any_instance_of(RecordsController).to receive(:redirect_after_create).and_return('/404.html')
  end

  scenario 'with a TuftsAudio' do
    visit '/records/new'

    select 'Audio', from: 'Select an object type'
    click_button 'Next'

    fill_in '* Title', with: 'My title'

    allow_any_instance_of(Audio).to receive(:attributes=).with({}) # called when initializing a new object
    expect_any_instance_of(Audio).to receive(:attributes=).with(params)
    # Avoid the catalog so we don't have to run Solr
    expect_any_instance_of(Audio).to receive(:save).and_return(true)
    click_button 'Save'
  end
end
