# frozen_string_literal: true
require 'simplecov'

SimpleCov.start do
  add_filter 'test.rb'
  add_filter '.bundler/'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'myra'
require 'webmock/rspec'

# try loading pry, but do not fret if it's not there

begin
  require 'pry'
rescue LoadError
  puts '[WARN] continuing without pry, consider adding it'
end
