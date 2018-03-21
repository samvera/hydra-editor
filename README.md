# HydraEditor [![Gem Version](https://badge.fury.io/rb/hydra-editor.png)](http://badge.fury.io/rb/hydra-editor) [![Build Status](https://travis-ci.org/samvera/hydra-editor.png)](https://travis-ci.org/samvera/hydra-editor)

To use add to your gemfile:

```ruby
gem 'hydra-editor'
```

Then run:
```
bundle install
```

Next generate the bootstrap form layouts:
```
rails generate simple_form:install --bootstrap
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
      model_label:
        PdfModel: "PDF"
        RecordedAudio: "audio"

  simple_form:
    labels:
      image:
        dateCreated: "Date Created"
        sub_location: "Holding Sub-location"
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

(Note: The Javascript includes require Blacklight and must be put after that.)

## Updating to 4.0.0

* [SimpleForm](https://github.com/plataformatec/simple_form) is supported from release 3.2.0 onwards
* `#to_model` now returns `self` (previously it was the value of `@model`):
  ```ruby
    class MyForm
      include HydraEditor::Form
      self.model_class = MyModel
      self.terms = [:title, :creator]
      # [...]
    end
    # [...]
    some_work = MyModel.new(title: ['Black holes: The Reith Lectures.'], creator: 'S.W. Hawking')
    some_form = MyForm.new(some_work)
    # [...]
    some_form.to_model
    # => #<MyForm:0x00007fd5b2fd1468 @attributes={"id"=>nil, "title"=>["Black holes: The Reith Lectures."], "creator"=>"S.W. Hawking"}, @model=#<MyModel id: nil, title: ["Black holes: The Reith Lectures."], creator: "S.W. Hawking">>
  ```
* When a form field for a single value is empty, it now returns a `nil` value (as opposed to an empty `String`):
  ```ruby
    class MyForm
      include HydraEditor::Form
      self.model_class = MyModel
      self.terms = [:title, :creator]
      # [...]
    end

    # [...]
    values = MyForm.model_attributes(
      title: ['On the distribution of values of angles determined by coplanar points.'],
      creator: ''
    )
    values['creator']
    # => nil
  ```

## Other customizations

By default `hydra-editor` provides a RecordsController with :new, :create, :edit, and :update actions implemented in the included RecordsControllerBehavior module, and a RecordsHelper module with methods implemented in RecordsHelperBehavior.  If you are mounting the engine and using its routes, you can override the controller behaviors by creating your own RecordsController:

```ruby
class RecordsController < ApplicationController
  include RecordsControllerBehavior

  # You custom code
end
```

If you are not mounting the engine or using its default routes, you can include RecordsControllerBehavior in your own controller and add the appropriate routes to your app's config/routes.rb.

# Samvera
This software has been developed by and is brought to you by the Samvera community.  Learn more at the
[Samvera website](https://samvera.org/)

![Samvera Logo](https://wiki.duraspace.org/download/thumbnails/87459292/samvera-fall-font2-200w.png?version=1&modificationDate=1498550535816&api=v2)
