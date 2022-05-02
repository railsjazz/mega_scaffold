module MegaScaffold
  class BaseController < ActionController::Base
    before_action :set_mega_scaffold_configs

    layout 'application'

    def index
      @records = collection
    end

    def show
      @record = resource
    end

    def new
      @record = @mega_scaffold[:model].new
    end

    def create
      @record = @mega_scaffold[:model].new(record_params)
      if @record.save
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
        redirect_to @record
      else
        render :edit
      end
    end    

    def destroy
      @record = resource
      @record.destroy
      redirect_to action: :index
    end

    private
    def set_mega_scaffold_configs
    end

    def record_params
      params.require(@mega_scaffold[:model].to_s.downcase).permit(@mega_scaffold[:form][:fields])
    end

  end
end