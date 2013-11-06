require 'spec_helper'

describe RecordsController do
  describe "an admin" do
    before do
      HydraEditor.models = ['Audio', 'Pdf']
      @user = FactoryGirl.create(:admin)
      sign_in @user
    end
    describe "who goes to the new page" do
      it "should be successful" do
        get :new, use_route: 'hydra_editor'
        response.should be_successful
        response.should render_template(:choose_type)
      end
      it "should be successful" do
        get :new, :type=>'Audio', :use_route=>'hydra_editor'
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
        post :create, :type=>'Audio', :audio=>{:title=>"My title"}, :use_route=>'hydra_editor'
        response.should redirect_to("/catalog/#{assigns[:record].id}") 
        assigns[:record].title.should == ['My title']
      end
      it "should be successful with json" do
        post :create, :type=>'Audio', :audio=>{:title=>"My title"}, :format=>:json, :use_route=>'hydra_editor'
        response.status.should == 201 
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
      describe "when redirect_after_create is overridden" do
        it "should redirect to the alternate location" do
          controller.stub(:redirect_after_create).and_return(root_url)
          post :create, :type=>'Audio', :audio=>{:title=>"My title"}, :use_route=>'hydra_editor'
          response.should redirect_to(root_url) 
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
        get :edit, :id=>@audio.pid, :use_route=>'hydra_editor'
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
        put :update, :id=>@audio, :audio=>{:title=>"My title 3"}, :use_route=>'hydra_editor'
        response.should redirect_to("/catalog/#{assigns[:record].id}") 
        assigns[:record].title.should == ['My title 3']
      end
      it "should be successful with json" do
        put :update, :id=>@audio.pid, :audio=>{:title=>"My title"}, :format=>:json, :use_route=>'hydra_editor'
        response.status.should == 204 
      end
      describe "when redirect_after_update is overridden" do
        it "should redirect to the alternate location" do
          controller.stub(:redirect_after_update).and_return(root_url)
          put :update, :id=>@audio, :audio=>{:title=>"My title 3"}, :use_route=>'hydra_editor'
          response.should redirect_to(root_url) 
        end
      end
    end
  end

  describe "a user without create ability" do
    before do
      @user =  FactoryGirl.create(:user)
      sign_in @user
      controller.current_ability.cannot :create, ActiveFedora::Base
    end
    describe "who goes to the new page" do
      it "should not be allowed" do
        lambda { get :new, :use_route=>'hydra_editor' }.should raise_error CanCan::AccessDenied
      end
    end
  end

end
