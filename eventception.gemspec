# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'eventception'

Gem::Specification.new do |spec|
  spec.name        = 'eventception'
  spec.version     = Eventception::VERSION
  spec.authors     = ['Daniel Gomes']
  spec.email       = ['danielcesargomes@gmail.com']
  spec.homepage    = 'https://github.com/dcsg/eventception'
  spec.summary     = 'Eventception - a lightweight and simple Ruby Event System.'
  spec.description = 'A lightweight and simple Ruby Event System inspired on Symfony Event Dispatcher.'
  spec.license     = 'MIT'

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug' unless RUBY_PLATFORM == 'java'
  spec.add_development_dependency 'pry-debugger-jruby' if RUBY_PLATFORM == 'java'
end
