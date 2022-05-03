module MegaScaffold
  module Routing
    def mega_scaffold(*options, fields: nil, except: [], only: [], collection: nil, parent: nil, concerns: nil)
      model_name  = options[0].to_s.singularize # user
      model       = model_name.classify.safe_constantize # User
      concerns    = Array.wrap(concerns)
      return unless model

     # fields = prepare_default_fields(model, Array.wrap(except).map(&:to_s), Array.wrap(only).map(&:to_s)) if fields.blank?
      fields = prepare_default_fields(model) if fields.blank?

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

    def prepare_default_fields(model)
      model.columns.map do |e|
        {
          name: e.name,
          type: MegaScaffold::TypeDetector.find_type(e),
        }
      end
    end

    # def prepare_default_fields(model, except, only)
    #   model.columns.map do |e|
    #     next if except.include?(e.name)
    #     {
    #       name: e.name,
    #       type: find_type(e),
    #     }
    #   end.compact.select do |e|
    #     only.empty? || only.include?(e[:name])
    #   end.compact
    # end   

  end
end
