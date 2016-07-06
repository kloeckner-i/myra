# frozen_string_literal: true
require 'date'
module Myra
  class Domain
    PATH = '/domains'
    OBJECT_TYPE = 'DomainVO'

    attr_reader :id
    attr_accessor :modified, :created, :name, :auto_update, :maintenance,
                  :paused, :owned, :reversed

    %w(auto_update maintenance owned paused reversed).each do |boolean|
      alias_method "#{boolean}?", boolean
    end

    def initialize(id:)
      @id = id
    end

    def self.from_hash(hash)
      domain = new(id: hash['id'])
      domain.modified = DateTime.parse(hash['modified'])
      domain.created = DateTime.parse(hash['created'])
      domain.auto_update = hash['autoUpdate']
      %w(modified created).each do |date_field|
        domain.send "#{date_field}=", DateTime.parse(hash[date_field])
      end
      %w(name paused owned reversed maintenance).each do |field|
        domain.send "#{field}=", hash[field]
      end
      domain
    end
  end
end
