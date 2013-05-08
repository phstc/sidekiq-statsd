# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "guard-yard"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pan Thomakos"]
  s.date = "2013-03-18"
  s.description = "Guard::Yard automatically monitors Yard Documentation."
  s.email = ["pan.thomakos@gmail.com"]
  s.homepage = "https://github.com/panthomakos/guard-yard"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "guard-yard"
  s.rubygems_version = "1.8.25"
  s.summary = "Guard gem for YARD"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<yard>, [">= 0.7.0"])
    else
      s.add_dependency(%q<guard>, [">= 1.1.0"])
      s.add_dependency(%q<yard>, [">= 0.7.0"])
    end
  else
    s.add_dependency(%q<guard>, [">= 1.1.0"])
    s.add_dependency(%q<yard>, [">= 0.7.0"])
  end
end
