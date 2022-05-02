module MegaScaffold
  class Engine < ::Rails::Engine
    initializer 'mega_scaffold.helpers', before: :load_config_initializers do
      ActiveSupport.on_load :action_view do
        include MegaScaffold::Helpers
      end
    end
  end
end
