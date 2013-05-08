# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pry"
  s.version = "0.9.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Mair (banisterfiend)", "Conrad Irwin", "Ryan Fitzgerald"]
  s.date = "2013-04-21"
  s.description = "An IRB alternative and runtime developer console"
  s.email = ["jrmair@gmail.com", "conrad.irwin@gmail.com", "rwfitzge@gmail.com"]
  s.executables = ["pry"]
  s.files = ["bin/pry"]
  s.homepage = "http://pry.github.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "An IRB alternative and runtime developer console"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<coderay>, ["~> 1.0.5"])
      s.add_runtime_dependency(%q<slop>, ["~> 3.4"])
      s.add_runtime_dependency(%q<method_source>, ["~> 0.8"])
      s.add_development_dependency(%q<bacon>, ["~> 1.2"])
      s.add_development_dependency(%q<open4>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<guard>, ["~> 1.3.2"])
      s.add_development_dependency(%q<mocha>, ["~> 0.13.1"])
      s.add_development_dependency(%q<bond>, ["~> 0.4.2"])
    else
      s.add_dependency(%q<coderay>, ["~> 1.0.5"])
      s.add_dependency(%q<slop>, ["~> 3.4"])
      s.add_dependency(%q<method_source>, ["~> 0.8"])
      s.add_dependency(%q<bacon>, ["~> 1.2"])
      s.add_dependency(%q<open4>, ["~> 1.3"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<guard>, ["~> 1.3.2"])
      s.add_dependency(%q<mocha>, ["~> 0.13.1"])
      s.add_dependency(%q<bond>, ["~> 0.4.2"])
    end
  else
    s.add_dependency(%q<coderay>, ["~> 1.0.5"])
    s.add_dependency(%q<slop>, ["~> 3.4"])
    s.add_dependency(%q<method_source>, ["~> 0.8"])
    s.add_dependency(%q<bacon>, ["~> 1.2"])
    s.add_dependency(%q<open4>, ["~> 1.3"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<guard>, ["~> 1.3.2"])
    s.add_dependency(%q<mocha>, ["~> 0.13.1"])
    s.add_dependency(%q<bond>, ["~> 0.4.2"])
  end
end
