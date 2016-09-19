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

  describe("#createNewChildren", function() {
    it("removes values and properties from an input tag", function() {
      var field = '<li class="field-wrapper"><input class="string multi_value optional text_title form-control multi-text-field" name="text[title][]" value="sample value" required id="text_title" aria-labelledby="text_title_label" type="text" /></li>'      
      expect($(field).find('input').val()).toEqual('sample value')
      expect($(field).find('input').attr('required')).toEqual('required');      
      var child = target.createNewChildren($(field))
      expect(child.val()).toEqual('')
      expect(child.attr('required')).toBeUndefined();
    })

    it("removes values and properties from a textarea tag", function() {
      var field = '<li class="field-wrapper"><textarea class="string multi_value optional text_title form-control multi-text-field" name="text[title][]" required id="text_title" aria-labelledby="text_title_label">sample value</textarea></li>'      
      expect($(field).find('textarea').val()).toEqual('sample value')
      expect($(field).find('textarea').attr('required')).toEqual('required');      
      var child = target.createNewChildren($(field))
      expect(child.val()).toEqual('')
      expect(child.attr('required')).toBeUndefined();
    })    
  })
});
