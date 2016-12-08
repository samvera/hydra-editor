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

  describe("#getFieldLabel", function() {
    it("only returns one label", function() {
      var field = '<div class="form-group multi_value optional generic_work_inscription nested-field managed"><label class="control-label multi_value optional" for="generic_work_inscription">Inscription</label><ul class="listing" aria-live="polite"> <li class="field-wrapper nested-field input-group input-append"> <div class="row multi_value">  <div class="col-md-3"><label for="generic_work_inscription_attributes_0_location">Location</label>  </div>  <div class="col-md-9"><input class="string multi_value optional generic_work_inscription form-control multi-text-field" name="generic_work[inscription_attributes][0][location]" id="generic_work_inscription_attributes_0_location" aria-labelledby="generic_work_inscription_label" type="text">  </div></div><div class="row multi_value">  <div class="col-md-3"><label for="generic_work_inscription_attributes_0_text">Text</label>  </div>  <div class="col-md-9"><textarea class="string multi_value optional generic_work_inscription form-control multi-text-field" name="generic_work[inscription_attributes][0][text]" id="generic_work_inscription_attributes_0_text" aria-labelledby="generic_work_inscription_label" rows="2"></textarea>  </div></div> <span class="input-group-btn field-controls"><button type="button" class="btn btn-link remove"><span class="glyphicon glyphicon-remove"></span><span class="controls-remove-text">Remove</span> <span class="sr-only"> previous <span class="controls-field-name-text"> InscriptionLocationText</span></span></button></span></li> </ul> </div> ';
      var options = { labelControls: true }
      expect(target.getFieldLabel($(field), options)).toEqual(' Inscription');
    });
  });
});
