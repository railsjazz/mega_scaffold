#ActionDispatch::Routing::Mapper

module MegaScaffold
  module Routing
    def mega_scaffold(*options)
      model_name = options[0].to_s.singularize
      model = model_name.classify.constantize

      str = %Q{
        class ::#{model.to_s.pluralize}Controller < MegaScaffold::BaseController
          helper :all

          def collection
            #{model}.all
          end

          def resource
            collection.find(params[:id])
          end

          private
          def set_mega_scaffold_configs
            @mega_scaffold = {
              model: #{model},
              index: {
                columns: #{model.column_names}
              },
              form: {
                fields: [:name, :age, :country, :about, :dob]
              }
            }
          end
        end
      }

      eval(str)

      resources *options
    end
  end
end
