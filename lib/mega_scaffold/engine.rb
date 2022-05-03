module MegaScaffold
  class Engine < ::Rails::Engine
    isolate_namespace MegaScaffold

    config.to_prepare do
    end

    initializer 'mega_scaffold.helpers', before: :load_config_initializers do
      ActiveSupport.on_load :action_view do
        include MegaScaffold::Helpers
      end

      ActiveSupport.on_load :action_controller do
      end
    end

    config.after_initialize do
    end
   
  end
end
