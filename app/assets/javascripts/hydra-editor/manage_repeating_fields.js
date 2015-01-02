// This widget manages the adding and removing of repeating fields.
// There are a lot of assumptions about the structure of the classes and elements.
// These assumptions are reflected in the MultiValueInput class.

(function($){

    var FieldManager = function (element, options) {
        this.element = $(element);
        this.options = options;

        this.controls = $("<span class=\"input-group-btn field-controls\">");
        this.remover  = $("<button class=\"btn btn-danger remove\"><i class=\"icon-white glyphicon-minus\"></i><span>Remove</span></button>");
        this.adder    = $("<button class=\"btn btn-success add\"><i class=\"icon-white glyphicon-plus\"></i><span>Add</span></button>");

        this.fieldWrapperClass = '.field-wrapper';
        this.warningClass = '.has-warning';
        this.listClass = '.listing';

        this.init();
    }

    FieldManager.prototype = {
        init: function () {
            this._addInitialClasses();
            this._appendControls();
            this._attachEvents();
            this._addCallbacks();
        },

        _addInitialClasses: function () {
            this.element.addClass("managed");
            $(this.fieldWrapperClass, this.element).addClass("input-group input-append");
        },

        _appendControls: function() {
            $(this.fieldWrapperClass, this.element).append(this.controls);
            $(this.fieldWrapperClass+':not(:last-child) .field-controls', this.element).append(this.remover);
            $('.field-controls:last', this.element).append(this.adder);
        },

        _attachEvents: function() {
            var _this = this;
            this.element.on('click', '.remove', function (e) {
              _this.remove_from_list(e);
            });
            this.element.on('click', '.add', function (e) {
              _this.add_to_list(e);
            });
        },

        _addCallbacks: function() {
            this.element.bind('managed_field:add', this.options.add);
            this.element.bind('managed_field:remove', this.options.remove);
        },

        add_to_list: function( event ) {
          event.preventDefault();
          var $activeField = $(event.target).parents(this.fieldWrapperClass)

          if ($activeField.children('input').val() === '') {
              this.displayEmptyWarning();
          } else {
            var $listing = $(this.listClass, this.element);
            this.clearEmptyWarning();
            $listing.append(this._newField($activeField));
          }
        },

        _newField: function($activeField) {
            var $removeControl = this.remover.clone(),
                $activeFieldControls = $activeField.children('.field-controls'),
                $newField = $activeField.clone();
            $('.add', $activeFieldControls).remove();
            $activeFieldControls.prepend($removeControl);
            $newChildren = $newField.children('input');
            $newChildren.val('').removeProp('required');
            $newChildren.first().focus();
            this.element.trigger("managed_field:add", $newChildren.first());
            return $newField;
        },

        clearEmptyWarning: function() {
            $listing = $(this.listClass, this.element),
            $listing.children(this.warningClass).remove();
        },

        displayEmptyWarning: function () {
            $listing = $(this.listClass, this.element)
            var $warningMessage  = $("<div class=\'message has-warning\'>cannot add new empty field</div>");
            $listing.children(this.warningClass).remove();
            $listing.append($warningMessage);
        },

        remove_from_list: function( event ) {
          event.preventDefault();

          var field = $(event.target).parents(this.fieldWrapperClass)
          field.remove();

          this.element.trigger("managed_field:remove", field);
        },

        destroy: function() {
          $(this.fieldWrapperClass, this.element).removeClass("input-append");
          this.element.removeClass( "managed" );
        }
    }

    FieldManager.DEFAULTS = {
        add: null,
        remove: null
    }

    $.fn.manage_fields = function(option) {
        return this.each(function() {
            var $this = $(this);
            var data  = $this.data('manage_fields');
            var options = $.extend({}, FieldManager.DEFAULTS, $this.data(), typeof option == 'object' && option);

            if (!data) $this.data('manage_fields', (data = new FieldManager(this, options)));
        })
    }
})(jQuery);
