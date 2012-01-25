$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rapid_transit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rapid_transit"
  s.version     = RapidTransit::VERSION
  s.authors     = ["Jay McAliley"]
  s.email       = ["jay.mcaliley@gmail.com"]
  s.homepage    = "https://github.com/jaymcaliley/rapid_transit"
  s.summary     = "A simple DSL for importing text files in Rails"
  s.description = "RapidTransit allows you to create text file parsers for use in a Ruby on Rails application."

  s.files = Dir["{app,config,db,lib}/**/**/*"] + ["MIT-LICENSE", "Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 2.3.8"

  s.add_development_dependency "sqlite3"
end
