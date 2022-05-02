module MegaScaffold
  module Routing
    DEFAULT_EXCEPT_FIELDS = ["id", "created_at", "updated_at"]

    def prepare_default_fields(model, except = [])
      model.columns.map do |e|
        next if except.include?(e.name.to_s)
        {
          name: e.name,
          type: e.type,
        }
      end.compact
    end

    def mega_scaffold(*options, fields: nil, except: DEFAULT_EXCEPT_FIELDS)
      model_name = options[0].to_s.singularize # user
      model      = model_name.classify.constantize # User
      except     = except.map(&:to_s)

      fields     = prepare_default_fields(model, except) if fields.blank?

      code = %Q{
        class ::#{model.to_s.pluralize}Controller < MegaScaffold::BaseController
          helper :all

          def parent
          end

          def collection
            #{model}.all
          end

          def resource
            collection.find(params[:id])
          end

          private
          def mega_scaffold
            @mega_scaffold ||= OpenStruct.new({
              model: #{model},
              fields: self.class.fields_config,
              columns: self.class.columns_config,
              form: self.class.form_config,
            })
          end
        end

        ::#{model.to_s.pluralize}Controller
      }
      klass = eval(code)
      #puts code

      klass.singleton_class.define_method :fields_config do
        fields
      end

      klass.singleton_class.define_method :columns_config do
        fields_config.select do |e|
          views = Array.wrap(e[:view]).map(&:to_sym)
          next true if views.empty?
          next true if views.include?(:index) || views.include?(:all)

          false
        end
      end

      klass.singleton_class.define_method :form_config do
        fields_config.select do |e|
          views = Array.wrap(e[:view]).map(&:to_sym)
          next true if views.empty?
          next true if views.include?(:form) || views.include?(:all)
          false
        end
      end

      #puts klass.form_config

     # binding.pry

      resources *options
    end

  end
end
