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
      "<button class=\"adder btn\" id=\"additional_test_submit\" name=\"additional_test\">+<span class=\"accessible-hidden\">add another test</span></button>"
  end

  it "draws subtract button" do
    helper.subtract_field(:test).should == 
      "<button class=\"remover btn\" id=\"additional_test_submit\" name=\"additional_test\">-<span class=\"accessible-hidden\">add another test</span></button>"
  end
end
