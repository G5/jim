$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jim/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jim"
  s.version     = Jim::VERSION
  s.authors     = ["Don Petersen"]
  s.email       = ["don@donpetersen.net"]
  s.homepage    = "https://github.com/G5/jim"
  s.summary     = "Jim"
  s.description = "Jim"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency "redcarpet"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "pry"
end
