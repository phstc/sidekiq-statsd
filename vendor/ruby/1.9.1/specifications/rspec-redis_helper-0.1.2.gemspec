# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rspec-redis_helper"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Lanett"]
  s.date = "2012-04-02"
  s.description = "Helper for RSpec tests which use Redis"
  s.email = ["mark.lanett@gmail.com"]
  s.homepage = "http://github.com/mlanett/rspec-redis_helper"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Helper for RSpec tests which use Redis"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
