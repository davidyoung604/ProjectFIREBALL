ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/reporters'
# scrap the param to 'use!' to go back to the progress bar output
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'simplecov'
SimpleCov.start

module ActiveSupport
  class TestCase
    # Setup fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def arr_includes_all?(arr, *inc)
      inc.map { |i| arr.include? i }.reduce(&:&)
    end
  end
end
