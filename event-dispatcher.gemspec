# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'event_dispatcher/version'

Gem::Specification.new do |spec|
  spec.name        = 'event-dispatcher'
  spec.version     = EventDispatcher::VERSION
  spec.authors     = ['Daniel Gomes']
  spec.email       = ['danielcesargomes@gmail.com']
  spec.homepage    = 'https://github.com/dcsg/ruby-event-dispatcher'
  spec.summary     = 'A simple Ruby Event Dispatcher.'
  spec.description = 'A Ruby Event Dispatcher based on Symfony Event Dispatcher.'
  spec.license     = 'MIT'

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'logging', '~> 2.1.0'
end
