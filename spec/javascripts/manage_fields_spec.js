describe("FieldManager", function() {

  var element = null;
  var hydra_editor = require('hydra-editor/field_manager');


  beforeEach(function() {
    setFixtures('<div class="form-group multi_value optional text_title"><label class="multi_value optional control-label" for="text_title">Title</label><div>    <ul class="listing"><li class="field-wrapper"><input class="string multi_value optional text_title form-control multi-text-field" name="text[title][]" value="" id="text_title" aria-labelledby="text_title_label" type="text" /></li></ul></div>')
    element = $('.multi_value.form-group')
    target = new hydra_editor.FieldManager(element, {
      removeHtml:        '<button class="remove">Remove</button>',
      fieldWrapperClass: '.field-wrapper',
      controlsHtml:      '<span class=\"input-group-btn field-controls\">'
        
    });
  });

  describe("initialization", function() {
    it("creates a remove button for each multi-input field", function() {
      expect(element.find('button.remove')).toExist()
    });
  });
});
