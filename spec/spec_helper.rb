$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'eventception'

RSpec.configure do |config|
end

if ENV['SIMPLECOV_ENABLED'] == '1'
  require 'simplecov'
  require 'simplecov-json'
  require 'simplecov-rcov'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::RcovFormatter,
  ]

  SimpleCov.start
end
