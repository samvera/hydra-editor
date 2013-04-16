= HydraEditor

To use add to your gemfile:

```ruby
gem 'hydra-editor'
```

And to config/routes.rb add:

```ruby
  mount HydraEditor::Engine => '/'
```

In your app/controllers/records_controller.rb override ```valid_types```

```ruby
class RecordsController < ApplicationController
  include RecordsControllerBehavior

  def valid_types
    ["Audio", "Pdf"]
  end
end
```

In your app/helpers/records_helper.rb override ```object_type_options```

```ruby
module RecordsHelper
  include RecordsHelperBehavior
  
  def object_type_options
    {'Audio' => 'Audio', 'PDF' => 'Pdf'}
  end
end
```


Expects the following interface on your hydra models:

```terms_for_editing``` returns an array of model attributes to edit

Add the javascript by adding this line to your app/assets/javascript/application.js:

```javascript
//= require hydra-editor/hydra-editor
```
