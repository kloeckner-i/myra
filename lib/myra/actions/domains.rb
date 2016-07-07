# frozen_string_literal: true
require 'oj'
module Myra
  module Domains
    PATH = '/domains'

    def self.list
      response = Request.new(path: PATH).do
      values = Oj.load(response.body)
      values['list'].map { |domain| Domain.from_hash(domain) }
    end

    def self.create(domain)
      request = Request.new(path: PATH, type: :put)
      request.payload = Oj.dump(domain.to_hash)
      response = request.do
      value = Oj.load(response.body)
      Domain.from_hash(value['targetObject'].first)
    end

    def self.delete(domain)
      request = Request.new(path: PATH, type: :delete)
      payload = domain.to_hash.select { |k, _| %w(id modified).include?(k) }

      request.payload = Oj.dump(payload)
      response = request.do
      value = Oj.load(response.body)
      Domain.from_hash(value['targetObject'].first)
    end

    def self.update(_domain)
    end
  end
end
