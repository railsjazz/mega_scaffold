module MegaScaffold
  class CodeGenerator
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def generate
      strs = []
      options[:namespaces].each_with_index do |e, index|
        strs << "#{' ' * index}module #{index == 0 ? '::' + e : e}"
      end

      strs << %Q{
        class #{'::' if options[:namespaces].empty?}#{options[:model].to_s.pluralize}Controller < ::ApplicationController
          include MegaScaffold::Controller
          include Helpers

          #{"include " + options[:concerns].join(", ") if options[:concerns].any?} 

          helper :all

          def parent
            mega_scaffold.parent.call(self) if mega_scaffold.parent.is_a?(Proc)
          end

          def collection
            mega_scaffold.collection.call(self)
          end

          def resource
            collection.find(params[:id])
          end

          def find_parent
            @parent = parent
          end

          private
          def mega_scaffold
            @mega_scaffold ||= OpenStruct.new({
              model: #{options[:model]},
              fields: self.class.fields_config,
              columns: self.class.columns_config,
              form: self.class.form_config,
              show: self.class.show_config,
              scope: #{options[:scope][:as].to_s.to_json},
              collection: self.class.collection_config,
              parent: self.class.parent_config,
            })
          end
        end
      }

      options[:namespaces].each_with_index do |e, index|
        strs << "#{' ' * (options[:namespaces].size - index - 1)}end"
      end

      klass_name = "#{options[:namespaces].any? ? options[:namespaces].join("::") + "::" : '::'}#{options[:model].to_s.pluralize}Controller"
      strs << klass_name

      # delete old constant
      # because it has conficts with same which was previosly initialized
      # happend after changing routes.rb in dev mode
      object_space = options[:namespaces].join("::").constantize rescue Object
      object_space.send(:remove_const, :"#{options[:model].to_s.pluralize}Controller") rescue '='

      strs.join("\n")
    end
  end
end