module MegaScaffold
  class FieldsGenerator
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def generate
      model.columns.map do |e|
        {
          name: e.name,
          type: MegaScaffold::TypeDetector.find_type(e),
        }
      end
    end
  end
end