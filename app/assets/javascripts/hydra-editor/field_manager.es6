export class FieldManager {
    constructor(element, options) {
        this.element = $(element);
        this.options = options;

        this.options.label = this.getFieldLabel(this.element, options)

        this.adder    = this.createAddHtml(this.options);
        this.remover  = this.createRemoveHtml(this.options);

        this.controls = $(options.controlsHtml);
        this.fieldWrapperClass = options.fieldWrapperClass;
        this.warningClass = options.warningClass;
        this.listClass = options.listClass;

        this.init();
    }

    init() {
        this._addInitialClasses();
        this._addAriaLiveRegions()
        this._appendControls();
        this._attachEvents();
        this._addCallbacks();
    }

    _addInitialClasses() {
        this.element.addClass("managed");
        $(this.fieldWrapperClass, this.element).addClass("input-group input-append");
    }

    _addAriaLiveRegions() {
        $(this.element).find('.listing').attr('aria-live', 'polite')
    }

    _appendControls() {
        $(this.fieldWrapperClass, this.element).append(this.controls);
        $(this.fieldWrapperClass + ' .field-controls', this.element).append(this.remover);

        if ($(this.element).find('.add').length == 0) {
            $(this.element).find(this.listClass).after(this.adder);
        }
    }

    _attachEvents() {
        this.element.on('click', '.remove', (e) => this.removeFromList(e));
        this.element.on('click', '.add', (e) =>this.addToList(e));
    }

    _addCallbacks() {
        this.element.bind('managed_field:add', this.options.add);
        this.element.bind('managed_field:remove', this.options.remove);
    }

    _manageFocus() {
        $(this.element).find(this.listClass).children('li').last().find('.form-control').focus();
    }

    addToList( event ) {
        event.preventDefault();
        let $listing = $(event.target).closest('.multi_value').find(this.listClass)
        let $activeField = $listing.children('li').last()

        if (this.inputIsEmpty($activeField)) {
            this.displayEmptyWarning();
        } else {
            this.clearEmptyWarning();
            $listing.append(this._newField($activeField));
        }

        this._manageFocus()
    }

    inputIsEmpty($activeField) {
        return $activeField.children('input.multi-text-field').val() === '';
    }

    _newField ($activeField) {
        var $newField = this.createNewField($activeField);
        return $newField;
    }

    createNewField($activeField) {
        let $newField = $activeField.clone();
        let $newChildren = this.createNewChildren($newField);
        this.element.trigger("managed_field:add", $newChildren);
        return $newField;
    }

    _changeControlsToRemove($activeField) {
        var $removeControl = this.remover.clone();
        $activeFieldControls = $activeField.children('.field-controls');
        $('.add', $activeFieldControls).remove();
        $activeFieldControls.prepend($removeControl);
    }

    clearEmptyWarning() {
        let $listing = $(this.listClass, this.element)
        $listing.children(this.warningClass).remove();
    }

    displayEmptyWarning() {
        let $listing = $(this.listClass, this.element)
        var $warningMessage  = $("<div class=\'message has-warning\'>cannot add another with empty field</div>");
        $listing.children(this.warningClass).remove();
        $listing.append($warningMessage);
    }

    removeFromList( event ) {
        event.preventDefault();
        var $listing = $(event.target).closest('.multi_value').find(this.listClass)
        var $field = $(event.target).parents(this.fieldWrapperClass).remove();
        this.element.trigger("managed_field:remove", $field);

        this._manageFocus();
    }

    destroy() {
        $(this.fieldWrapperClass, this.element).removeClass("input-append");
        this.element.removeClass("managed");
    }

    getFieldLabel($element, options) {
        var label = '';
        var $label = $element.find("label").first();

        if ($label.size && options.labelControls) {
          var label = $label.data('label') || $.trim($label.contents().filter(function() { return this.nodeType === 3; }).text());
          label = ' ' + label;
        }

        return label;
    }

    createAddHtml(options) {
        var $addHtml  = $(options.addHtml);
        $addHtml.find('.controls-add-text').html(options.addText + options.label);
        return $addHtml;
    }

    createRemoveHtml(options) {
        var $removeHtml = $(options.removeHtml);
        $removeHtml.find('.controls-remove-text').html(options.removeText);
        $removeHtml.find('.controls-field-name-text').html(options.label);
        return $removeHtml;
    }

    createNewChildren(clone) {
        let $newChildren = $(clone).children('.multi_value');
        $newChildren.val('').removeProp('required');
        $newChildren.first().focus();
        return $newChildren.first();
    }
}
