# frozen_string_literal: true
require 'base64'
require 'openssl'

module Myra
  class Request
    class Signature
      REQUEST_STRING = 'myra-api-request'
      attr_reader :secret, :date, :base

      def initialize(secret:, date:, base: 'MYRA')
        @secret = secret
        @date = date
        @base = base
      end

      def date_key
        method.(digest, "#{base}#{secret}", date)
      end

      def signing_key
        method.(digest, date_key, REQUEST_STRING)
      end

      def for(signing_string)
        base64.(hmac_method.(digest('sha512'), signing_key, signing_string))
      end

      private

      def digest(type = 'sha256')
        OpenSSL::Digest.new(type)
      end

      def method
        OpenSSL::HMAC.method(:hexdigest)
      end

      def hmac_method
        OpenSSL::HMAC.method(:digest)
      end

      def base64
        Base64.method(:strict_encode64)
      end
    end
  end
end
