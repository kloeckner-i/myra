# frozen_string_literal: true

require 'myra/request/signature'
require 'myra/request/http'
require 'date'

module Myra
  class Request
    attr_reader :date, :api_key, :api_secret
    attr_accessor :type

    ALLOWED_TYPES = [
      :get,
      :post,
      :put,
      :options,
      :head,
      :delete
    ].freeze

    def initialize(value_object_class)
      @date = DateTime.now.to_s
      @api_key = Myra.configuration.api_key
      @api_secret = Myra.configuration.api_secret
      @type = :get
      unless value_object_class.const_defined?('PATH')
        raise ValueObjectUndefinedError
      end

      @klass = value_object_class
    end

    def signing_string
      [
        md5.(payload),
        verb,
        uri,
        content_type,
        date
      ].join '#'
    end

    def type=(type)
      raise InvalidRequestTypeError unless ALLOWED_TYPES.include?(type)
      @type = type
    end

    def do
      HTTP.new(self).response
    end

    def uri
      "/en/rapi#{@klass::PATH}"
    end

    def content_type
      'application/json'
    end

    private

    def md5
      Digest::MD5.method(:hexdigest)
    end

    def payload
      ''
    end

    def verb
      type.to_s.upcase
    end
  end
end
