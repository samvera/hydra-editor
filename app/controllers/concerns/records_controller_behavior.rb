module RecordsControllerBehavior
  def new
    authorize! :create, ActiveFedora::Base
    unless has_valid_type?
      render 'choose_type'
      return
    end

    @record = params[:type].constantize.new
    initialize_fields
  end

  def edit
    @record = ActiveFedora::Base.find(params[:id], cast: true)
    authorize! :edit, @record
    initialize_fields
  end

  def create
    authorize! :create, ActiveFedora::Base
    unless has_valid_type?
      redirect_to hydra_editor.new_record_path, :flash=> {error: "Lost the type"}
      return
    end
    @record = params[:type].constantize.new
    set_attributes

    respond_to do |format|
      if @record.save
        format.html { redirect_to main_app.catalog_path(@record), notice: 'Object was successfully created.' }
        # ActiveFedora::Base#to_json causes a circular reference.  Do somethign easy
        data = @record.terms_for_editing.inject({}) { |h,term|  h[term] = @record[term]; h } 
        format.json { render json: data, status: :created, location: hydra_editor.record_path(@record) }
      else
        format.html { render action: "new" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @record = ActiveFedora::Base.find(params[:id], cast: true)
    authorize! :update, @record
    set_attributes
    respond_to do |format|
      if @record.save
        format.html { redirect_to main_app.catalog_path(@record), notice: 'Object was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  # Override this method if you want to set different metadata on the object
  def set_attributes
    @record.attributes = params[@record.class.model_name.underscore]
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
