module MegaScaffold
  class Engine < ::Rails::Engine
    isolate_namespace MegaScaffold

    initializer 'mega_scaffold.helpers', before: :load_config_initializers do
      ActiveSupport.on_load :action_view do
        include MegaScaffold::Helpers
      end
    end

    ActionDispatch::Routing::Mapper.send :include, MegaScaffold::Routing
  end
end
