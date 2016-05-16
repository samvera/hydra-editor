// This widget manages the adding and removing of repeating fields.
// There are a lot of assumptions about the structure of the classes and elements.
// These assumptions are reflected in the MultiValueInput class.

var HydraEditor = (function($) {
    var FieldManager = function (element, options) {
        this.element = $(element);
        this.options = options;

        this.options.label = getFieldLabel(this.element, options)

        this.adder    = createAddHtml(this.options);
        this.remover  = createRemoveHtml(this.options);

        this.controls = $(options.controlsHtml);
        this.fieldWrapperClass = options.fieldWrapperClass;
        this.warningClass = options.warningClass;
        this.listClass = options.listClass;

        this.init();
    }

    FieldManager.prototype = {
        init: function () {
            this._addInitialClasses();
            this._addAriaLiveRegions()
            this._appendControls();
            this._attachEvents();
            this._addCallbacks();
        },

        _addInitialClasses: function() {
            this.element.addClass("managed");
            $(this.fieldWrapperClass, this.element).addClass("input-group input-append");
        },

        _addAriaLiveRegions: function() {
            $(this.element).find('.listing').attr('aria-live', 'polite')
        },

        _appendControls: function() {
            $(this.fieldWrapperClass, this.element).append(this.controls);
            $(this.fieldWrapperClass+' .field-controls', this.element).append(this.remover);

            if ($(this.element).find('.add').length == 0) {
                $(this.element).find(this.listClass).after(this.adder);
            }
        },

        _attachEvents: function() {
            var _this = this;
            this.element.on('click', '.remove', function (e) {
              _this.removeFromList(e);
            });
            this.element.on('click', '.add', function (e) {
              _this.addToList(e);
            });
        },

        _addCallbacks: function() {
            this.element.bind('managed_field:add', this.options.add);
            this.element.bind('managed_field:remove', this.options.remove);
        },

        _manageFocus: function() {
            $(this.element).find(this.listClass).children('li').last().find('.form-control').focus();
        },

        addToList: function( event ) {
            event.preventDefault();
            var $listing = $(event.target).closest('.multi_value').find(this.listClass)
            $activeField = $listing.children('li').last()

            if (this.inputIsEmpty($activeField)) {
                this.displayEmptyWarning();
            } else {
                this.clearEmptyWarning();
                $listing.append(this._newField($activeField));
            }

            this._manageFocus()
        },

        inputIsEmpty: function($activeField) {
            return $activeField.children('input.multi-text-field').val() === '';
        },

        _newField: function ($activeField) {
            var $newField = this.createNewField($activeField);
            return $newField;
        },

        createNewField: function($activeField) {
            $newField = $activeField.clone();
            $newChildren = $newField.children('input');
            $newChildren.val('').removeProp('required');
            $newChildren.first().focus();
            this.element.trigger("managed_field:add", $newChildren.first());
            return $newField;
        },

        _changeControlsToRemove: function($activeField) {
            var $removeControl = this.remover.clone();
            $activeFieldControls = $activeField.children('.field-controls');
            $('.add', $activeFieldControls).remove();
            $activeFieldControls.prepend($removeControl);
        },

        clearEmptyWarning: function() {
            $listing = $(this.listClass, this.element),
            $listing.children(this.warningClass).remove();
        },

        displayEmptyWarning: function () {
            $listing = $(this.listClass, this.element)
            var $warningMessage  = $("<div class=\'message has-warning\'>cannot add another with empty field</div>");
            $listing.children(this.warningClass).remove();
            $listing.append($warningMessage);
        },

        removeFromList: function( event ) {
            event.preventDefault();
            var $listing = $(event.target).closest('.multi_value').find(this.listClass)
            var $field = $(event.target).parents(this.fieldWrapperClass).remove();
            this.element.trigger("managed_field:remove", $field);

            this._manageFocus();
        },

        destroy: function() {
            $(this.fieldWrapperClass, this.element).removeClass("input-append");
            this.element.removeClass( "managed" );
        }
    }

    // Initialization helper functions
    var getFieldLabel = function($element, options) {
      var label = '';
      var $label = $element.find("label");

      if ($label.size && options.labelControls) {
        var label = $label.data('label') || $.trim($label.contents().filter(function() { return this.nodeType === 3; }).text());
        label = ' ' + label;
      }

      return label;
    }

    var createAddHtml = function(options) {
      var $addHtml  = $(options.addHtml);
      $addHtml.find('.controls-add-text').html(options.addText + options.label);
      return $addHtml;
    }

    var createRemoveHtml = function(options) {
      var $removeHtml = $(options.removeHtml);
      $removeHtml.find('.controls-remove-text').html(options.removeText);
      $removeHtml.find('.controls-field-name-text').html(options.label);
      return $removeHtml;
    }

    FieldManager.DEFAULTS = {
        /* callback to run after add is called */
        add:    null,
        /* callback to run after remove is called */
        remove: null,

        controlsHtml:      '<span class=\"input-group-btn field-controls\">',
        fieldWrapperClass: '.field-wrapper',
        warningClass:      '.has-warning',
        listClass:         '.listing',

        addHtml:           '<button type=\"button\" class=\"btn btn-link add\"><span class=\"glyphicon glyphicon-plus\"></span><span class="controls-add-text"></span></button>',
        addText:           'Add another',

        removeHtml:        '<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span><span class="controls-remove-text"></span> <span class=\"sr-only\"> previous <span class="controls-field-name-text">field</span></span></button>',
        removeText:         'Remove',

        labelControls:      true,
    }

    return { FieldManager: FieldManager };
})(jQuery);

(function($){
    $.fn.manage_fields = function(option) {
        return this.each(function() {
            var $this = $(this);
            var data  = $this.data('manage_fields');
            var options = $.extend({}, HydraEditor.FieldManager.DEFAULTS, $this.data(), typeof option == 'object' && option);

            if (!data) $this.data('manage_fields', (data = new HydraEditor.FieldManager(this, options)));
        })
    }
})(jQuery);
