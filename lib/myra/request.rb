# frozen_string_literal: true

require 'myra/request/signature'
require 'myra/request/http'
require 'date'

module Myra
  class Request
    attr_reader :date, :api_key, :api_secret, :path
    attr_accessor :type

    ALLOWED_TYPES = [
      :get,
      :post,
      :put,
      :options,
      :head,
      :delete
    ].freeze

    def initialize(path:, type: :get)
      @date = DateTime.now.to_s
      @api_key = Myra.configuration.api_key
      @api_secret = Myra.configuration.api_secret
      @type = type
      @path = path
    end

    def signing_string
      [
        md5.(payload),
        verb,
        "#{Myra::PATH}#{path}",
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

    def content_type
      'application/json'
    end

    def uri
      "#{Myra::BASE_URL}#{Myra::PATH}#{path}"
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
