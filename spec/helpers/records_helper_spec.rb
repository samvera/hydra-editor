require 'spec_helper'

describe RecordsHelper do
  it 'should have object_type_options' do
    HydraEditor.models = ['Audio', 'Pdf']
    allow(I18n).to receive(:t).with('hydra_editor.form.model_label.Audio', default: 'Audio').and_return('Audio')
    allow(I18n).to receive(:t).with('hydra_editor.form.model_label.Pdf', default: 'Pdf').and_return('PDF')
    expect(helper.object_type_options).to eq('Audio' => 'Audio', 'PDF' => 'Pdf')
  end

  it 'draws edit_record_title' do
    allow(helper).to receive(:form).and_return(double(title: 'My Title'))
    expect(helper.edit_record_title).to eq 'Edit My Title'
  end

  describe 'render_edit_field_partial' do
    before do
      class Dragon; end
      class Serpent; end
    end
    let(:f) { double('form') }
    it 'draws partial elements based on class of the object' do
      allow(f).to receive(:object).and_return(Dragon.new)
      expect(helper).to receive(:partial_exists?).and_return(true)
      expect(helper).to receive(:render).with('dragons/edit_fields/name', f: f, key: :name)
      helper.render_edit_field_partial(:name, f: f)
      allow(f).to receive(:object).and_return(Serpent.new)
      expect(helper).to receive(:partial_exists?).and_return(true)
      expect(helper).to receive(:render).with('serpents/edit_fields/name', f: f, key: :name)
      helper.render_edit_field_partial(:name, f: f)
    end

    it "draws the default partial if the path isn't found" do
      allow(f).to receive(:object).and_return(Dragon.new)
      expect(helper).to receive(:partial_exists?).exactly(4).times.and_return(false, false, false, true)
      expect(helper).to receive(:render).with('records/edit_fields/default', f: f, key: :name)
      helper.render_edit_field_partial(:name, f: f)
    end

    it 'logs the paths it looked for' do
      allow(f).to receive(:object).and_return(Dragon.new)
      expect(helper).to receive(:partial_exists?).and_return(false, true)
      expect(Rails.logger).to receive(:debug).exactly(2).times
      expect(helper).to receive(:render).with('records/edit_fields/name', f: f, key: :name)
      helper.render_edit_field_partial(:name, f: f)
    end
  end
end
