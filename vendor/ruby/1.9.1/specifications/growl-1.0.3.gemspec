# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "growl"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = "2009-07-25"
  s.description = "growlnotify bindings"
  s.email = "tj@vision-media.ca"
  s.extra_rdoc_files = ["lib/growl/growl.rb", "lib/growl/images/error.png", "lib/growl/images/info.png", "lib/growl/images/ok.png", "lib/growl/images/warning.png", "lib/growl/version.rb", "lib/growl.rb", "README.rdoc", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.files = ["lib/growl/growl.rb", "lib/growl/images/error.png", "lib/growl/images/info.png", "lib/growl/images/ok.png", "lib/growl/images/warning.png", "lib/growl/version.rb", "lib/growl.rb", "README.rdoc", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.homepage = "http://github.com/visionmedia/growl"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Growl", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "growl"
  s.rubygems_version = "1.8.25"
  s.summary = "growlnotify bindings"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
