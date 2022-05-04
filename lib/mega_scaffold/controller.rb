module MegaScaffold
  module Controller
    extend ActiveSupport::Concern
 
    included do
      prepend_view_path("#{MegaScaffold::Engine.root}/app/views")
      before_action :find_parent
      layout :detect_layout
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
        redirect_to url_for({ action: :show, mega_scaffold.pk => @record.send(mega_scaffold.pk) })
      else
        render template: 'mega_scaffold/new', status: :unprocessable_entity
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
        redirect_to url_for({ action: :show, mega_scaffold.pk => @record.send(mega_scaffold.pk) })
      else
        render template: 'mega_scaffold/edit', status: :unprocessable_entity
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
        result = ee[:column].presence || ee[:name]
        if result.is_a?(Hash)
          if result[:permit]
            { result[:name] => result[:permit] }
          else
            result[:name]
          end
        else
          result
        end
      end.compact
    end

    def record_params
      params.require(mega_scaffold.model.to_s.downcase).permit(mega_scaffold_permits)
    end

  end
end