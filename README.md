# HydraEditor

To use add to your gemfile:

```ruby
gem 'hydra-editor'
```

And to config/routes.rb add:

```ruby
  mount HydraEditor::Engine => '/'
```

In your initialization set ```HydraEditor.models```

```ruby
# config/initializers/hydra_editor.rb
HydraEditor.models = ["RecordedAudio", "PdfModel"]
```

You can customize the names of your fields/models by adding to your translation file:

```yaml
# config/locales/en.yml
en:
  hydra:
    field_label:
      source2: "Alternate Source"
      dateCreated: "Date Created"
      dateAvailable: "Date Available"
    model_label:
      PdfModel: "PDF"
      RecordedAudio: "audio"

```

Expects the following interface on your hydra models:

```terms_for_editing``` returns an array of model attributes to edit

Add the javascript by adding this line to your app/assets/javascript/application.js:

```javascript
//= require hydra-editor/hydra-editor
```

Add the stylesheets by adding this line to your app/assets/stylesheets/application.css:
```css
 *= require hydra-editor/hydra-editor
```
