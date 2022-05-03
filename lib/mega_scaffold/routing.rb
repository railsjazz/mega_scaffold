module MegaScaffold
  module Routing
    DEFAULT_EXCEPT_FIELDS = ["id", "created_at", "updated_at"]

    def mega_scaffold(*options, fields: nil, except: DEFAULT_EXCEPT_FIELDS, collection: nil, parent: nil, concerns: nil)
      model_name  = options[0].to_s.singularize # user
      model       = model_name.classify.safe_constantize # User
      except      = except.map(&:to_s)
      concerns    = Array.wrap(concerns)
      return unless model

      fields = prepare_default_fields(model, except) if fields.blank?

      generator = MegaScaffold::CodeGenerator.new({
        namespaces: @scope[:module].to_s.split("/").map{|e| e.classify},
        concerns: concerns,
        model: model,
        scope: @scope
      })

      code = generator.generate
      klass = eval(code)

      MegaScaffold::KlassDecorator.new(klass, {
        fields: fields,
        collection: collection,
        parent: parent,
        model: model
      }).decorate

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
