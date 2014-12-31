# HydraEditor [![Gem Version](https://badge.fury.io/rb/hydra-editor.png)](http://badge.fury.io/rb/hydra-editor) [![Build Status](https://travis-ci.org/projecthydra-labs/hydra-editor.png)](https://travis-ci.org/projecthydra-labs/hydra-editor)


To use add to your gemfile:

```ruby
gem 'hydra-editor'
```

And to config/routes.rb add:

```ruby
  mount HydraEditor::Engine => '/'
```

(Note: You do not have to mount the engine if you do not intend to use the engine's default routes.)

In your initialization set ```HydraEditor.models```

```ruby
# config/initializers/hydra_editor.rb
HydraEditor.models = ["RecordedAudio", "PdfModel"]
```

You can customize the names of your fields/models by adding to your translation file:

```yaml
# config/locales/en.yml
en:
  hydra_editor:
    form:
      field_label:
        source2: "Alternate Source"
        dateCreated: "Date Created"
        dateAvailable: "Date Available"
      model_label:
        PdfModel: "PDF"
        RecordedAudio: "audio"

```

Create a form object for each of your models.

```ruby
# app/forms/recorded_audio_form.rb
class RecordedAudioForm
  include HydraEditor::Form
  self.model_class = RecordedAudio
  self.terms = [] # Terms to be edited
  self.required_fields = [] # Required fields
end
```

Add the javascript by adding this line to your app/assets/javascript/application.js:

```javascript
//= require hydra-editor/hydra-editor
```

Add the stylesheets by adding this line to your app/assets/stylesheets/application.css:

```css
 *= require hydra-editor/hydra-editor
```

(Note: The Javascript includes require Blacklight and jQuery UI and must be put
after those.)

## Other customizations

By default hydra-editor provides a RecordsController with :new, :create, :edit, and :update actions implemented in the included RecordsControllerBehavior module, and a RecordsHelper module with methods implemented in RecordsHelperBehavior.  If you are mounting the engine and using its routes, you can override the controller behaviors by creating your own RecordsController:

```ruby
class RecordsController < ApplicationController
  include RecordsControllerBehavior

  # You custom code
end
```

If you are not mounting the engine or using its default routes, you can include RecordsControllerBehavior in your own controller and add the appropriate routes to your app's config/routes.rb.
