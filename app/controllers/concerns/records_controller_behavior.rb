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
    @record.attributes = params[@record.class.model_name.underscore]
    @record.save!

    redirect_to main_app.catalog_path(@record)
  end

  def update
    @record = ActiveFedora::Base.find(params[:id], cast: true)
    authorize! :update, @record
    @record.attributes = params[@record.class.model_name.underscore]
    @record.save!

    redirect_to main_app.catalog_path(@record)
  end

  protected

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
