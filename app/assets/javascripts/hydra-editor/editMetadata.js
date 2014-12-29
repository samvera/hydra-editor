Blacklight.onLoad(function() {
  $('body').on('keypress', '.multi-text-field', function(event) {
    var $activeField = $(event.target).parents('.field-wrapper'),
        $activeFieldControls = $activeField.children('.field-controls'),
        $addControl = $activeFieldControls.children('.add'),
        $removeControl = $activeFieldControls.children('.remove');
    if (event.keyCode == 13) {
      event.preventDefault();
      $addControl.click()
      $removeControl.click()
    }
  });

  $('.multi_value.form-group').manage_fields();
}
