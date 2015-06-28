# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = "kitchen-wright"
  s.license       = "Apache-2.0"
  s.version       = "0.0.1"
  s.authors       = ["Jörg Herzinger"]
  s.email         = ["joerg.herzinger@oiml.at"]
  s.homepage      = "https://github.com/joerg/kitchen-wright"
  s.summary       = "wright provisioner for test-kitchen"
  candidates = Dir.glob("{lib}/**/*") +  ['README.md', 'kitchen-wright.gemspec']
  s.files = candidates.sort
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
  s.description = <<-EOF
== DESCRIPTION:

A test-kitchen provisioner provisioner for wright

== FEATURES:

Supports running wright-scripts

EOF
  s.add_runtime_dependency 'test-kitchen'
end
