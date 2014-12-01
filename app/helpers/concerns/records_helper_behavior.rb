module RecordsHelperBehavior

  def metadata_help(key)
    I18n.t("hydra_editor.form.metadata_help.#{key}", default: key.to_s.humanize)
  end

  def field_label(key)
    I18n.t("hydra_editor.form.field_label.#{key}", default: key.to_s.humanize)
  end

  def model_label(key)
    I18n.t("hydra_editor.form.model_label.#{key}", default: key.to_s.humanize)
  end

  def object_type_options
    @object_type_options ||= HydraEditor.models.inject({}) do |h, model|
        label = model_label(model)
        h["#{label[0].upcase}#{label[1..-1]}"] = model
        h
    end
  end

  def render_edit_field_partial(field_name, locals)
    collection = ActiveSupport::Inflector.tableize(locals[:f].object.class.to_s)
    render_edit_field_partial_with_action(collection, field_name, locals)
  end

  def add_field (key)
    more_or_less_button(key, 'adder', '+')
  end

  def subtract_field (key)
    more_or_less_button(key, 'remover', '-')
  end

  def record_form_action_url(record)
    router = respond_to?(:hydra_editor) ? hydra_editor : self
    record.new_record? ? router.records_path : router.record_path(record)
  end

  def new_record_title
    I18n.t('hydra_editor.new.title') % model_label(params[:type])
  end

  def edit_record_title
    I18n.t('hydra_editor.edit.title') % render_record_title
  end

  def render_record_title
    Array(resource.title).first
  end

 protected

  # This finds a partial based on the record_type and field_name
  # if no partial exists for the record_type it tries using "records" as a default
  def render_edit_field_partial_with_action(record_type, field_name, locals)
    partial = find_edit_field_partial(record_type, field_name)
    render partial: partial, locals: locals.merge({key: field_name})
  end

  def find_edit_field_partial(record_type, field_name)
    ["#{record_type}/edit_fields/_#{field_name}", "records/edit_fields/_#{field_name}",
     "#{record_type}/edit_fields/_default", "records/edit_fields/_default"].find do |partial|
      logger.debug "Looking for edit field partial #{partial}"
      return partial.sub(/\/_/, '/') if partial_exists?(partial)
    end
  end

  def partial_exists?(partial)
    lookup_context.find_all(partial).any?
  end

  def more_or_less_button(key, html_class, symbol)
    # TODO, there could be more than one element with this id on the page, but the fuctionality doesn't work without it.
    content_tag('button', class: "#{html_class} btn btn-default", id: "additional_#{key}_submit", name: "additional_#{key}") do
      (symbol +
      content_tag('span', class: 'sr-only') do
        "add another #{key.to_s}"
      end).html_safe
    end
  end
end
