module RecordsControllerBehavior
  extend ActiveSupport::Concern
  
  included do
    before_filter :load_and_authorize_record, only: [:edit, :update]
  end

  def new
    authorize! :create, ActiveFedora::Base
    unless has_valid_type?
      render 'records/choose_type'
      return
    end

    @record = params[:type].constantize.new
    initialize_fields
    render 'records/new'
  end

  def edit
    initialize_fields
    render 'records/edit'
  end

  def create
    authorize! :create, ActiveFedora::Base
    unless has_valid_type?
      redirect_to(respond_to?(:hydra_editor) ? hydra_editor.new_record_path : new_record_path, flash: {error: "Lost the type"})
      return
    end
    @record = params[:type].constantize.new
    set_attributes

    respond_to do |format|
      if @record.save
        format.html { redirect_to redirect_after_create, notice: 'Object was successfully created.' }
        # ActiveFedora::Base#to_json causes a circular reference.  Do something easy
        data = @record.terms_for_editing.inject({}) { |h,term|  h[term] = @record[term]; h } 
        format.json { render json: data, status: :created, location: redirect_after_create }
      else
        format.html { render action: "new" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    set_attributes
    respond_to do |format|
      if @record.save
        format.html { redirect_to redirect_after_update, notice: 'Object was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def load_and_authorize_record
    load_record
    authorize_record!
  end

  def load_record
    @record = ActiveFedora::Base.find(params[:id], cast: true)
  end

  def authorize_record!
    authorize! params[:action].to_sym, @record
  end

  # Override this method if you want to set different metadata on the object
  def set_attributes
    @record.attributes = params[ActiveModel::Naming.singular(@record)]
  end

  # Override to redirect to an alternate location after create
  def redirect_after_create
    main_app.catalog_path @record
  end

  # Override to redirect to an alternate location after update
  def redirect_after_update
    main_app.catalog_path @record
  end

  def has_valid_type?
    HydraEditor.models.include? params[:type]
  end

  def initialize_fields
    @record.terms_for_editing.each do |key|
      # if value is empty, we create an one element array to loop over for output 
      @record[key] = [''] if @record[key].empty?
    end
  end
end
