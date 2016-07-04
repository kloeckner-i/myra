# frozen_string_literal: true
require 'faraday'
require 'oj'

module Myra
  class Request
    class HTTP
      BASE_URL = 'https://api.myracloud.com'

      def initialize(request)
        @request = request
        @signature = Signature.new(
          secret: Myra.configuration.api_secret,
          date: request.date
        )
      end

      def response
        @response ||= perform_request
      end

      private

      def perform_request
        conn.send(@request.type) do |req|
          req.headers['Content-Type'] = @request.content_type
          req.headers['Date'] = @request.date
          req.headers['Authorization'] = auth_header
        end
      end

      def conn
        Faraday.new(url: "#{BASE_URL}#{@request.uri}")
      end

      def api_key
        @request.api_key
      end

      def auth_signature
        @signature.for @request.signing_string
      end

      def auth_header
        "MYRA #{api_key}:#{auth_signature}"
      end
    end
  end
end
