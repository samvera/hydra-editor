require 'deprecation'
module RecordsHelperBehavior
  extend Deprecation
  
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

  def render_edit_field_partial(key, locals)
    collection = ActiveSupport::Inflector.tableize(locals[:f].object.class)
    render_edit_field_partial_with_action(collection, key, locals)
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

  def render_edit_field_partial_with_action(requested_path, key, locals)
    path = if partial_exists?("#{requested_path}/edit_fields", key)
      "#{requested_path}/edit_fields/#{key}"
    elsif partial_exists?("records/edit_fields", key) # for backwards compatibility
      Deprecation.warn RecordsHelperBehavior, "Rendering view from `records/edit_fields/#{key}`. Move to #{requested_path}/edit_fields/#{key}. This will be removed in 1.0.0"
      "records/edit_fields/#{key}"
    elsif partial_exists?("#{requested_path}/edit_fields", 'default')
      "#{requested_path}/edit_fields/default"
    else
      "records/edit_fields/default"
    end
    render partial: path, locals: locals.merge({key: key})
  end

  def partial_exists?(path, file)
    lookup_context.find_all("#{path}/_#{file}").any?
  end
  
  def more_or_less_button(key, html_class, symbol)
    # TODO, there could be more than one element with this id on the page, but the fuctionality doesn't work without it.
    content_tag('button', class: "#{html_class} btn", id: "additional_#{key}_submit", name: "additional_#{key}") do
      (symbol + 
      content_tag('span', class: 'sr-only') do
        "add another #{key.to_s}"
      end).html_safe
    end
  end
  
end
