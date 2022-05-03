module MegaScaffold
  class KlassDecorator
    attr_reader :klass, :options

    def initialize(klass, options)
      @klass = klass
      @options = options
    end

    def decorate
      # hack to have local variable available for define_method
      local = options

      klass.singleton_class.define_method :fields_config do
        local[:fields]
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

      klass.singleton_class.define_method :show_config do
        fields_config.select do |e|
          views = Array.wrap(e[:view]).map(&:to_sym)
          next true if views.empty?
          next true if views.include?(:show) || views.include?(:all)

          false
        end
      end      

      klass.singleton_class.define_method :collection_config do
        if local[:collection].is_a?(Proc)
          local[:collection]
        else
          -> (controller) { local[:model].all }
        end
      end

      klass.singleton_class.define_method :parent_config do
        local[:parent]
      end
    end
  end
end