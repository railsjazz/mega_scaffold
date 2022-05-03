module MegaScaffold
  module Controller
    extend ActiveSupport::Concern
 
    included do
      prepend_view_path("#{MegaScaffold::Engine.root}/app/views")
      before_action :find_parent
      layout 'application'
      helper_method :mega_scaffold
    end

    def index
      @records = if defined?(Kaminari)
        collection.page(params[:page])
      elsif defined?(WillPaginate)
        collection.paginate(params[:page])
      else
        collection
      end
      render template: 'mega_scaffold/index'
    end

    def show
      @record = resource
      render template: 'mega_scaffold/show'
    end

    def new
      @record = collection.new
      render template: 'mega_scaffold/new'
    end

    def create
      @record = collection.build(record_params)
      if @record.save
        flash[:notice] = "#{mega_scaffold.model} successfully created"
        redirect_to mega_scaffold_form_url(@record)
      else
        render template: 'mega_scaffold/new'
      end
    end

    def edit
      @record = resource
      render template: 'mega_scaffold/edit'
    end

    def update
      @record = resource
      if @record.update(record_params)
        flash[:notice] = "#{mega_scaffold.model} successfully updated"
        redirect_to mega_scaffold_form_url(@record)
      else
        render template: 'mega_scaffold/edit'
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