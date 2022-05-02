module MegaScaffold
  class BaseController < ActionController::Base
    include Helpers

    before_action :find_parent

    layout 'application'

    helper_method :mega_scaffold

    def index
      @records = if defined?(Kaminari)
        collection.page(params[:page])
      elsif defined?(WillPaginate)
        collection.paginate(params[:page])
      else
        collection
      end
    end

    def show
      @record = resource
    end

    def new
      @record = collection.new
    end

    def create
      @record = collection.build(record_params)
      if @record.save
        flash[:notice] = "#{mega_scaffold.model} successfully created"
        redirect_to mega_scaffold_form_url(@record)
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
        redirect_to mega_scaffold_form_url(@record)
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
        next if ee[:type] == :virtual
        ee[:column].presence || ee[:name]
      end.compact
    end

    def record_params
      params.require(mega_scaffold.model.to_s.downcase).permit(mega_scaffold_permits)
    end

  end
end