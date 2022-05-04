require_relative "lib/mega_scaffold/version"

Gem::Specification.new do |spec|
  spec.name        = "mega_scaffold"
  spec.version     = MegaScaffold::VERSION
  spec.authors     = ["Igor Kasyanchuk"]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  spec.homepage    = "https://github.com/railsjazz/mega_scaffold"
  spec.summary     = "Fastest way to add CRUD functionality to your models."
  spec.description = "Fastest way to add CRUD functionality to your Rails models. No jQuery or other frontend dependencies."
  spec.license     = "MIT"
  
  spec.metadata["homepage_uri"] = 'https://www.railsjazz.com/'
  spec.metadata["source_code_uri"] = "https://github.com/railsjazz/mega_scaffold"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails"

  spec.add_development_dependency "puma"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "country_select"
  spec.add_development_dependency "sassc"
  spec.add_development_dependency "kaminari"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "carrierwave"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "simplecov"  
  spec.add_development_dependency "wrapped_print"  
  spec.add_development_dependency "ppp-util"
end
