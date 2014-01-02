require 'spec_helper'

describe RecordsController do
  routes { HydraEditor::Engine.routes }
  before do
    HydraEditor.models = ['Audio', 'Pdf']
  end
  describe "an admin" do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      sign_in user
    end
    describe "who goes to the new page" do
      it "should be successful" do
        get :new
        response.should be_successful
        response.should render_template(:choose_type)
      end
      it "should be successful" do
        get :new, :type=>'Audio'
        response.should be_successful
        response.should render_template(:new)
      end
    end

    describe "creating a new record" do
      before do
        stub_audio = Audio.new(pid: 'test:6')
        stub_audio.stub(:persisted?).and_return(true)
        Audio.should_receive(:new).and_return(stub_audio)
        stub_audio.should_receive(:save).and_return(true)
      end
      it "should be successful" do
        post :create, :type=>'Audio', :audio=>{:title=>"My title"}
        response.should redirect_to("/catalog/#{assigns[:record].id}") 
        assigns[:record].title.should == ['My title']
      end
      it "should not set attributes that aren't listed in terms_for_editing" do
        # params[:audio][:collection_id] would be a good test, but that doesn't work in ActiveFedora 6.7
        post :create, :type=>'Audio', :audio=>{isPartOf: 'my collection'}
        response.should redirect_to("/catalog/#{assigns[:record].id}") 
        expect(assigns[:record].isPartOf).to eq [] 
      end
      it "should be successful with json" do
        post :create, :type=>'Audio', :audio=>{:title=>"My title"}, :format=>:json
        response.status.should == 201 
      end

      describe "when the user has access to create only some classes" do
        before do
          controller.current_ability.cannot :create, ActiveFedora::Base
          controller.current_ability.can :create, Audio
        end
        it "should be successful" do
          post :create, :type=>'Audio', :audio=>{:title=>"My title"}
          response.should redirect_to("/catalog/#{assigns[:record].id}") 
          assigns[:record].title.should == ['My title']
        end
      end
      describe "when set_attributes is overloaded" do
        controller(RecordsController) do
          def set_attributes
            super
            @record.creator = "Fleece Vest"
          end
        end
        it "should run set_attributes" do
          post :create, :type=>'Audio', :audio=>{:title=>"My title"}
          response.should redirect_to("/catalog/#{assigns[:record].id}") 
          assigns[:record].creator.should == ["Fleece Vest"]
        end
      end
      describe "when object_as_json is overloaded" do
        before do
          controller.stub(:object_as_json).and_return({message: 'it works'} )
        end
        it "should run object_as_json" do
          post :create, :type=>'Audio', :audio=>{:title=>"My title"}, format: 'json'
          expect(JSON.parse(response.body)).to eq({"message" => "it works"})
          expect(response.code).to eq '201'
        end
      end
      describe "when redirect_after_create is overridden" do
        it "should redirect to the alternate location" do
          controller.stub(:redirect_after_create).and_return('/')
          post :create, :type=>'Audio', :audio=>{:title=>"My title"}
          response.should redirect_to('/') 
        end
      end
    end

    describe "editing a record" do
      before do
        @audio = Audio.new(title: 'My title2', pid: 'test:7')
        ActiveFedora::Base.should_receive(:find).with('test:7', cast:true).and_return(@audio)
        controller.should_receive(:authorize!).with(:edit, @audio)
      end
      it "should be successful" do
        get :edit, :id=>@audio.pid
        response.should be_successful
        assigns[:record].title.should == ['My title2']
      end
    end

    describe "updating a record" do
      before do
        @audio = Audio.new(title: 'My title2', pid: 'test:7')
        @audio.stub(:persisted?).and_return(true)
        @audio.should_receive(:save).and_return(true)
        ActiveFedora::Base.should_receive(:find).with('test:7', cast:true).and_return(@audio)
        controller.should_receive(:authorize!).with(:update, @audio)
      end
      it "should be successful" do
        put :update, :id=>@audio, :audio=>{:title=>"My title 3"}
        response.should redirect_to("/catalog/#{assigns[:record].id}") 
        assigns[:record].title.should == ['My title 3']
      end
      it "should be successful with json" do
        put :update, :id=>@audio.pid, :audio=>{:title=>"My title"}, :format=>:json
        response.status.should == 204 
      end
      describe "when redirect_after_update is overridden" do
        it "should redirect to the alternate location" do
          controller.stub(:redirect_after_update).and_return('/')
          put :update, :id=>@audio, :audio=>{:title=>"My title 3"}
          response.should redirect_to('/') 
        end
      end
    end
  end

  describe "a user without create ability" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      controller.current_ability.cannot :create, Audio
    end
    describe "who goes to the new page" do
      it "should not be allowed" do
        lambda { get :new, type: 'Audio' }.should raise_error CanCan::AccessDenied
      end
    end
  end

end
