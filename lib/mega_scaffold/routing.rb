module MegaScaffold
  module Routing
    DEFAULT_EXCEPT_FIELDS = ["id", "created_at", "updated_at"]

    def mega_scaffold(*options, fields: nil, except: DEFAULT_EXCEPT_FIELDS, collection: nil)
      model_name  = options[0].to_s.singularize # user
      model       = model_name.classify.safe_constantize # User
      except      = except.map(&:to_s)
      namespaces  = @scope[:module].to_s.split("/").map{|e| e.classify}
      return unless model

      fields = prepare_default_fields(model, except) if fields.blank?

      strs = []
      namespaces.each_with_index do |e, index|
        strs << "#{' ' * index}module #{index == 0 ? '::' + e : e}"
      end

      code = %Q{
        class #{'::' if namespaces.empty?}#{model.to_s.pluralize}Controller < MegaScaffold::BaseController
          helper :all

          def parent
            # TODO
          end

          def collection
            mega_scaffold.collection
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
              scope: #{@scope[:as].to_s.to_json},
              collection: self.class.collection_config
            })
          end
        end
      }

      strs << code
      namespaces.each_with_index do |e, index|
        strs << "#{' ' * (namespaces.size - index - 1)}end"
      end

      strs << %Q{
        #{namespaces.any? ? namespaces.join("::") + "::" : '::'}#{model.to_s.pluralize}Controller
      }

      code = strs.join("\n")

      #puts code

      klass = eval(code)

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

      klass.singleton_class.define_method :collection_config do
        if collection.is_a?(Proc)
          collection.call
        else
          model.all
        end
      end

      resources *options

    rescue ActiveRecord::StatementInvalid => ex
      puts ex.message
    end

    private

    def prepare_default_fields(model, except = [])
      model.columns.map do |e|
        next if except.include?(e.name.to_s)
        {
          name: e.name,
          type: e.type,
        }
      end.compact
    end    

  end
end
