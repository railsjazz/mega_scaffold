require "mega_scaffold/version"
require "mega_scaffold/helpers"
require "mega_scaffold/routing"
require_relative "../app/controllers/mega_scaffold/base_controller"
require "mega_scaffold/engine"

module MegaScaffold
end

ActionDispatch::Routing::Mapper.send :include, MegaScaffold::Routing
