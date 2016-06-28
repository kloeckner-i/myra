# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'myra'

# try loading pry, but do not fret if it's not there

begin
  require 'pry'
rescue LoadError
  puts '[WARN] continuing without pry, consider adding it'
end
