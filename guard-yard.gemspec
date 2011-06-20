# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/yard/version"

Gem::Specification.new do |s|
  s.name        = "guard-yard"
  s.version     = Guard::Yard::VERSION
  s.authors     = ["Pan Thomakos"]
  s.email       = ["pan.thomakos@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Guard gem for YARD}
  s.description = %q{Guard::Yard automatically monitors Yard Documentation.}

  s.rubyforge_project = "guard-yard"
  s.required_ruby_version = '>= 1.9.2'
  s.add_dependency 'guard', '>= 0.2.2'
  s.add_dependency 'yard', '>= 0.7.0'

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.markdown]
  s.require_paths = ["lib"]
end
