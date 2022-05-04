require "mega_scaffold/version"
require "mega_scaffold/helpers"
require "mega_scaffold/controller"
require "mega_scaffold/fields_generator"
require "mega_scaffold/code_generator"
require "mega_scaffold/klass_decorator"
require "mega_scaffold/type_detector"
require "mega_scaffold/routing"
require "mega_scaffold/engine"

module MegaScaffold
end

ActionDispatch::Routing::Mapper.send :include, MegaScaffold::Routing