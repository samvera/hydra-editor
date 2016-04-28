describe("HydraEditor.FieldManager", function() {

  var element = null;

  describe("HydraEditor.FieldManager", function() {

    beforeEach(function() {
      setFixtures('<div class="form-group multi_value optional text_title"><label class="multi_value optional control-label" for="text_title">Title</label><div>    <ul class="listing"><li class="field-wrapper"><input class="string multi_value optional text_title form-control multi-text-field" name="text[title][]" value="" id="text_title" aria-labelledby="text_title_label" type="text" /></li></ul></div>')
      element = $('.multi_value.form-group')
      target = new HydraEditor.FieldManager(element, HydraEditor.FieldManager.DEFAULTS);
    });

    describe("initialization", function() {
      it("creates an add button", function() {
        expect(element.find('.btn-success.add')).toExist()
      });
    });
  });
});
