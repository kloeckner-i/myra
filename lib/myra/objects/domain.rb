# frozen_string_literal: true
require 'date'
module Myra
  class Domain
    PATH = '/domains'
    OBJECT_TYPE = 'DomainVO'

    attr_reader :id
    attr_accessor :modified, :created, :name, :auto_update, :maintenance,
                  :paused, :owned, :reversed, :auto_dns, :paused_until

    %w(auto_update maintenance owned paused reversed auto_dns).each do |boolean|
      alias_method "#{boolean}?", boolean
    end

    MAP = {
      # response field => target field
      'name' => 'name',
      'autoUpdate' => 'auto_update',
      'maintenance' => 'maintenance',
      'owned' => 'owned',
      'reversed' => 'reversed',
      'paused' => 'paused',
      'autoDns' => 'auto_dns'
    }.freeze

    def initialize(id: nil)
      @id = id
      %w(maintenance auto_update auto_dns paused owned reversed).each do |field|
        send("#{field}=", false)
      end
    end

    def self.from_hash(hash)
      domain = new(id: hash['id'])
      %w(modified created).each do |date_field|
        domain.send "#{date_field}=", DateTime.parse(hash[date_field])
      end
      MAP.each do |k, v|
        domain.send "#{v}=", hash[k]
      end
      domain
    end

    def to_hash
      return new_domain_hash if id.nil?
      domain_hash
    end

    private

    def new_domain_hash
      Hash[MAP.map { |k, v| [k, send(v)] }]
    end

    def domain_hash
      hash = new_domain_hash
      hash['id'] = id
      hash['modified'] = modified.to_s
      hash['created'] = created.to_s
      hash
    end
  end
end
