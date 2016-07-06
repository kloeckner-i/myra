# frozen_string_literal: true
module Myra
  class DnsRecord
    PATH = '/dnsRecords'

    attr_reader :id
    attr_accessor :name, :value, :ttl, :type, :alternative_cname,
                  :active, :modified, :created

    alias active? active

    MAP = {
      # response field => target field
      'name' => 'name',
      'value' => 'value',
      'ttl' => 'ttl',
      'alternativeCname' => 'alternative_cname',
      'active' => 'active',
      'recordType' => 'type'
    }.freeze

    def initialize(id:)
      @id = id
    end

    def self.from_hash(hash)
      domain = new(id: hash['id'])
      hash.each do |k, v|
        next unless MAP.key? k
        domain.send "#{MAP[k]}=", v
      end
      domain.modified = DateTime.parse(hash['modified'])
      domain.created = DateTime.parse(hash['created'])
      domain
    end
  end
end
