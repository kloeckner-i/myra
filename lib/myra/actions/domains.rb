# frozen_string_literal: true
require 'oj'
module Myra
  module Domains
    PATH = '/domains'

    def self.list
      response = Myra::Request.new(path: PATH).do
      values = Oj.load(response.body)
      values['list'].map { |domain| Domain.from_hash(domain) }
    end

    def self.create(_domain)
    end

    def self.delete(_domain)
    end

    def self.update(_domain)
    end
  end
end
