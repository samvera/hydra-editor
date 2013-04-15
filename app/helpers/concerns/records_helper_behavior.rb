module RecordsHelperBehavior
  
  def metadata_help(key)
    I18n.t("hydra.metadata_help.#{key}", default: key.to_s.humanize)
  end

  def field_label(key)
    I18n.t("hydra.field_label.#{key}", default: key.to_s.humanize)
  end

  def object_type_options
    {'Audio' => 'Audio', 'PDF' => 'Pdf'}
  end

  def render_edit_field_partial(key, locals)
    render_edit_field_partial_with_action('records', key, locals)
  end

  def render_batch_edit_field_partial(key, locals)
    render_edit_field_partial_with_action('batch_edit', key, locals)
  end

 private 

  def render_edit_field_partial_with_action(action, key, locals)
    ["#{action}/edit_fields/#{key}", "#{action}/edit_fields/default"].each do |str|
      # XXX rather than handling this logic through exceptions, maybe there's a Rails internals method
      # for determining if a partial template exists..
      begin
        return render :partial => str, :locals=>locals.merge({key: key})
      rescue ActionView::MissingTemplate; end
    end
    nil
  end
end
