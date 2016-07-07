# frozen_string_literal: true
require 'myra/version'
require 'myra/configuration'
require 'myra/request'

# actions which can be performed
require 'myra/actions/domains'
require 'myra/actions/dns_records'

# objects which can be retrieved
require 'myra/objects/domain'
require 'myra/objects/dns_record'

# possible errors
require 'myra/objects/errors'

# and their violations
require 'myra/objects/violation'

# Myra is the top level module for this gem
module Myra
  BASE_URL = 'https://api.myracloud.com'
  PATH = '/en/rapi'
end
