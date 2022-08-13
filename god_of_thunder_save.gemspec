# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "god_of_thunder_save"
  s.version     = "0.1.0"
  s.summary     = "God of Thunder saved game editor"
  s.description = "Read and write to God of Thunder saved games as models"
  s.authors     = ["Maxwell Pray"]
  s.email       = "synthead@gmail.com"
  s.files       = [
    "lib/god_of_thunder_save.rb",
    "lib/god_of_thunder_save/bitmask_value.rb",
    "lib/god_of_thunder_save/integer_value.rb",
    "lib/god_of_thunder_save/string_value.rb"
  ]
  s.homepage    = "https://github.com/synthead/god_of_thunder_save"
  s.license     = "MIT"

  s.add_development_dependency "rspec", "~> 3.11.0"
  s.add_development_dependency "fakefs", "~> 1.8.0"
end
