require_relative "lib/mega_scaffold/version"

Gem::Specification.new do |spec|
  spec.name        = "mega_scaffold"
  spec.version     = MegaScaffold::VERSION
  spec.authors     = [""]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  #spec.homepage    = ""
  spec.summary     = ": Summary of MegaScaffold."
  spec.description = ": Description of MegaScaffold."
  spec.license     = "MIT"
  
 # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails"
  spec.add_dependency "simple_form"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "country_select"
  spec.add_development_dependency "sassc"
end
