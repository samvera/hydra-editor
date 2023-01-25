require 'spec_helper'

describe RecordsHelper do
  let(:title_values) do
    double(title: 'My Title')
  end

  before do
    HydraEditor.models = ['Audio', 'Pdf']
    allow(helper).to receive(:form).and_return(title_values)
  end

  it 'has object_type_options' do
    allow(I18n).to receive(:t).with('hydra_editor.form.model_label.Audio', default: 'Audio').and_return('Audio')
    allow(I18n).to receive(:t).with('hydra_editor.form.model_label.Pdf', default: 'Pdf').and_return('PDF')
    expect(helper.object_type_options).to eq('Audio' => 'Audio', 'PDF' => 'Pdf')
  end

  it 'draws edit_record_title' do
    expect(helper.edit_record_title).to eq 'Edit My Title'
  end

  describe 'render_edit_field_partial' do
    before do
      class Dragon
        extend ActiveModel::Naming

        def multiple?(_key)
          false
        end

        def required?(_key)
          false
        end
      end

      class Serpent
        extend ActiveModel::Naming

        def multiple?(_key)
          false
        end

        def required?(_key)
          false
        end
      end
    end

    after do
      Object.send(:remove_const, :Dragon)
      Object.send(:remove_const, :Serpent)
    end

    let(:f) { double('form') }
    it 'draws partial elements based on class of the object' do
      allow(f).to receive(:object).and_return(Dragon.new)
      allow(helper).to receive(:partial_exists?).and_return(true)
      allow(helper).to receive(:render)
      helper.render_edit_field_partial(:name, f: f)
      expect(helper).to have_received(:partial_exists?)
      expect(helper).to have_received(:render).with('dragons/edit_fields/name', f: f, key: :name)
    end

    context "with a serpent" do
      it "draws partial elements for the Serpent model" do
        allow(f).to receive(:object).and_return(Serpent.new)
        allow(f).to receive(:input)
        allow(helper).to receive(:partial_exists?).and_return(true)
        allow(helper).to receive(:render)
        helper.render_edit_field_partial(:name, f: f)
        expect(helper).to have_received(:partial_exists?)
        expect(helper).to have_received(:render).with('serpents/edit_fields/name', f: f, key: :name)
      end
    end

    it "draws the default partial if the path isn't found" do
      allow(f).to receive(:object).and_return(Dragon.new)
      allow(helper).to receive(:partial_exists?).exactly(4).times.and_return(false, false, false, true)
      allow(helper).to receive(:render)
      helper.render_edit_field_partial(:name, f: f)
      expect(helper).to have_received(:render).with('records/edit_fields/default', f: f, key: :name)
    end

    it 'logs the paths it looked for' do
      allow(f).to receive(:object).and_return(Dragon.new)
      allow(helper).to receive(:partial_exists?).and_return(false, true)
      allow(helper).to receive(:render)
      allow(Rails.logger).to receive(:debug)
      helper.render_edit_field_partial(:name, f: f)
      expect(Rails.logger).to have_received(:debug).exactly(2).times
      expect(helper).to have_received(:render).with('records/edit_fields/name', f: f, key: :name)
    end
  end
end
