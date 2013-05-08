# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "guard-bundler"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yann Lugrin"]
  s.date = "2012-06-15"
  s.description = "Guard::Bundler automatically install/update your gem bundle when needed"
  s.email = ["yann.lugrin@sans-savoir.net"]
  s.homepage = "http://rubygems.org/gems/guard-bundler"
  s.rdoc_options = ["--charset=UTF-8", "--main=README.md", "--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "guard-bundler"
  s.rubygems_version = "1.8.25"
  s.summary = "Guard gem for Bundler"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>, ["~> 1.1"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 1.0"])
    else
      s.add_dependency(%q<guard>, ["~> 1.1"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<guard-rspec>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<guard>, ["~> 1.1"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<guard-rspec>, ["~> 1.0"])
  end
end
