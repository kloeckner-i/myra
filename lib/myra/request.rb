# frozen_string_literal: true

require 'myra/request/signature'
require 'date'

module Myra
  class Request
    attr_reader :date, :api_key, :api_secret
    def initialize(value_object_class)
      @date = DateTime.now.to_s
      @api_key = Myra.configuration.api_key
      @api_secret = Myra.configuration.api_secret
      unless value_object_class.const_defined?('PATH')
        raise ValueObjectUndefinedError
      end
    end
  end
end
