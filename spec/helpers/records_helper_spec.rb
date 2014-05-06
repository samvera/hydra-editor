require 'spec_helper'

describe RecordsHelper do
  it "should have object_type_options" do
    HydraEditor.models = ['Audio', 'Pdf']
    I18n.stub(:t).with("hydra_editor.form.model_label.Audio", default: 'Audio').and_return('Audio')
    I18n.stub(:t).with("hydra_editor.form.model_label.Pdf", default: 'Pdf').and_return('PDF')
    helper.object_type_options.should == {'Audio' => 'Audio', 'PDF' => 'Pdf'}
  end

  it "draws add button" do
    helper.add_field(:test).should == 
      "<button class=\"adder btn\" id=\"additional_test_submit\" name=\"additional_test\">+<span class=\"sr-only\">add another test</span></button>"
  end

  it "draws subtract button" do
    helper.subtract_field(:test).should == 
      "<button class=\"remover btn\" id=\"additional_test_submit\" name=\"additional_test\">-<span class=\"sr-only\">add another test</span></button>"
  end

  it "draws edit_record_title" do
    helper.stub(:resource).and_return(double(title:"My Title"))
    expect(helper.edit_record_title).to eq "Edit My Title"
  end

  describe "render_edit_field_partial" do
    before do
      class Dragon; end
      class Serpent; end
    end
    let(:f) { double("form") }
    it "draws partial elements based on class of the object" do
      f.stub(object: Dragon.new)
      helper.should_receive(:partial_exists?).and_return(true)
      helper.should_receive(:render).with(partial: "dragons/edit_fields/name", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
      f.stub(object: Serpent.new)
      helper.should_receive(:partial_exists?).and_return(true)
      helper.should_receive(:render).with(partial: "serpents/edit_fields/name", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
    end

    it "draws the default partial if the path isn't found" do
      f.stub(object: Dragon.new)
      helper.should_receive(:partial_exists?).exactly(3).times.and_return(false)
      helper.should_receive(:render).with(partial: "records/edit_fields/default", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
    end

    it "shows deprecation if they have the path in records/" do
      f.stub(object: Dragon.new)
      helper.should_receive(:partial_exists?).and_return(false, true)
      Deprecation.should_receive(:warn)
      helper.should_receive(:render).with(partial: "records/edit_fields/name", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
    end
  end
end
