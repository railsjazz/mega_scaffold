module MegaScaffold
  module Routing
    IGNORE_FORM_COLUMNS = [:id, :created_at, :updated_at]

    def mega_scaffold(*options, fields: nil, ignore: IGNORE_FORM_COLUMNS, except: [], only: [], collection: nil, parent: nil, concerns: nil)
      model_name  = options[0].to_s.singularize # user
      model       = model_name.classify.safe_constantize # User
      concerns    = Array.wrap(concerns)
      return unless model

      fields    = MegaScaffold::FieldsGenerator.new(model).generate if fields.blank?
      generator = MegaScaffold::CodeGenerator.new({
        namespaces: @scope[:module].to_s.split("/").map{|e| e.classify},
        concerns: concerns,
        model: model,
        scope: @scope
      })

      klass = eval(generator.generate)

      MegaScaffold::KlassDecorator.new(klass, {
        fields: fields,
        collection: collection,
        parent: parent,
        model: model,
        except: except,
        only: only,
        ignore: ignore
      }).decorate

      resources *options
    rescue ActiveRecord::StatementInvalid => ex
      puts ex.message
    end

  end
end
