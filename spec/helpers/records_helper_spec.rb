require 'spec_helper'

describe RecordsHelper do
  it "should have object_type_options" do
    HydraEditor.models = ['Audio', 'Pdf']
    allow(I18n).to receive(:t).with("hydra_editor.form.model_label.Audio", default: 'Audio').and_return('Audio')
    allow(I18n).to receive(:t).with("hydra_editor.form.model_label.Pdf", default: 'Pdf').and_return('PDF')
    expect(helper.object_type_options).to eq('Audio' => 'Audio', 'PDF' => 'Pdf')
  end

  it "draws add button" do
    expect(helper.add_field(:test)).to eq "<button class=\"adder btn btn-default\" id=\"additional_test_submit\" name=\"additional_test\">+<span class=\"sr-only\">add another test</span></button>"
  end

  it "draws subtract button" do
    expect(helper.subtract_field(:test)).to eq "<button class=\"remover btn btn-default\" id=\"additional_test_submit\" name=\"additional_test\">-<span class=\"sr-only\">add another test</span></button>"
  end

  it "draws edit_record_title" do
    allow(helper).to receive(:resource).and_return(double(title:"My Title"))
    expect(helper.edit_record_title).to eq "Edit My Title"
  end

  describe "render_edit_field_partial" do
    before do
      class Dragon; end
      class Serpent; end
    end
    let(:f) { double("form") }
    it "draws partial elements based on class of the object" do
      allow(f).to receive(:object).and_return(Dragon.new)
      expect(helper).to receive(:partial_exists?).and_return(true)
      expect(helper).to receive(:render).with(partial: "dragons/edit_fields/name", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
      allow(f).to receive(:object).and_return(Serpent.new)
      expect(helper).to receive(:partial_exists?).and_return(true)
      expect(helper).to receive(:render).with(partial: "serpents/edit_fields/name", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
    end

    it "draws the default partial if the path isn't found" do
      allow(f).to receive(:object).and_return(Dragon.new)
      expect(helper).to receive(:partial_exists?).exactly(3).times.and_return(false)
      expect(helper).to receive(:render).with(partial: "records/edit_fields/default", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
    end

    it "shows deprecation if they have the path in records/" do
      allow(f).to receive(:object).and_return(Dragon.new)
      expect(helper).to receive(:partial_exists?).and_return(false, true)
      expect(Deprecation).to receive(:warn)
      expect(helper).to receive(:render).with(partial: "records/edit_fields/name", locals: {f: f, key: :name})
      helper.render_edit_field_partial(:name, f: f)
    end
  end
end
