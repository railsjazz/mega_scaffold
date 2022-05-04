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

      klass.singleton_class.define_method :rules do
        {
          except: (Array.wrap(local[:except]) + Array.wrap(local[:ignore])).map(&:to_sym),
          only: (Array.wrap(local[:only]) - Array.wrap(local[:ignore])).map(&:to_sym),
        }
      end

      klass.singleton_class.define_method :fields_config do
        local[:fields].map do |e|
          e.merge({view: Array.wrap(e[:view]).map(&:to_sym)}).deep_symbolize_keys
        end
      end

      klass.singleton_class.define_method :columns_config do
        fields_config.select do |e|
          next true if e[:view].empty?
          next true if e[:view].include?(:index) || e[:view].include?(:all)

          false
        end
      end

      klass.singleton_class.define_method :form_config do
        fields_config.select do |e|
          next false if rules[:except].any? && rules[:except].include?(e[:name].to_sym)
          next false if rules[:only].any? && !rules[:only].include?(e[:name].to_sym)

          next true if e[:view].empty?
          next true if e[:view].include?(:form) || e[:view].include?(:all)
          false
        end
      end

      klass.singleton_class.define_method :show_config do
        fields_config.select do |e|
          next true if e[:view].empty?
          next true if e[:view].include?(:show) || e[:view].include?(:all)

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