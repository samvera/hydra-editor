= HydraEditor

To use add to your gemfile:

```ruby
gem 'hydra-editor'
```

And to config/routes.rb add:

```ruby
  mount HydraEditor::Engine => '/'
```


Expects the following interface on your hydra models:

```terms_for_editing``` returns an array of model attributes to edit
