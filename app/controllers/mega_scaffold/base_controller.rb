module MegaScaffold
  class BaseController < ActionController::Base
    helper_method :mega_scaffold

    layout 'application'

    def index
      @records = collection
    end

    def show
      @record = resource
    end

    def new
      @record = mega_scaffold.model.new
    end

    def create
      @record = mega_scaffold.model.new(record_params)
      if @record.save
        flash[:notice] = "#{mega_scaffold.model} successfully created"
        redirect_to @record
      else
        render :new
      end
    end

    def edit
      @record = resource
    end

    def update
      @record = resource
      if @record.update(record_params)
        flash[:notice] = "#{mega_scaffold.model} successfully updated"
        redirect_to @record
      else
        render :edit
      end
    end    

    def destroy
      @record = resource
      @record.destroy
      flash[:notice] = "#{mega_scaffold.model} successfully deleted"
      redirect_to action: :index
    end

    private

    def mega_scaffold_permits
      mega_scaffold.fields.map do |ee|
        ee[:column].presence || ee[:name]
      end
    end

    def record_params
      params.require(mega_scaffold.model.to_s.downcase).permit(mega_scaffold_permits)
    end

  end
end