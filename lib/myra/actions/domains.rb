# frozen_string_literal: true
require 'oj'

module Myra
  module Domains
    PATH = '/domains'

    def self.list
      values = handle Request.new(path: PATH)
      values['list'].map { |domain| Domain.from_hash(domain) }
    end

    def self.create(domain)
      request = Request.new(path: PATH, type: :put)
      request.payload = Oj.dump(domain.to_hash)
      value = handle request
      Domain.from_hash(value['targetObject'].first)
    end

    def self.delete(domain)
      request = Request.new(path: PATH, type: :delete)
      payload = domain.to_hash.select { |k, _| %w(id modified).include?(k) }
      request.payload = Oj.dump(payload)
      value = handle request
      Domain.from_hash(value['targetObject'].first)
    end

    def self.update(domain)
      request = Request.new path: PATH, type: :post
      payload = domain.to_hash.select do |k, _|
        %w(id modified autoUpdate).include? k
      end
      request.payload = Oj.dump(payload)
      value = handle request
      Domain.from_hash(value['targetObject'].first)
    end

    def self.handle(request)
      response = request.do
      raise APIAuthError if response.status == 403
      Oj.load(response.body)
    end

    private_class_method :handle
  end
end
