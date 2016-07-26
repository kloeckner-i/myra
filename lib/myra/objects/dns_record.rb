# frozen_string_literal: true
module Myra
  class DnsRecord
    PATH = '/dnsRecords'

    # Record types
    class Type
      CNAME = 'CNAME'
      A = 'A'
    end

    attr_reader :id
    attr_accessor :name, :value, :ttl, :type, :alternative_cname,
                  :active, :modified, :created
    attr_writer :deleted

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

    def initialize(id: nil)
      @id = id
      @active = true
      @type = Type::A
      @ttl = 300
      @deleted = false
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

    def to_hash
      return new_record_hash if id.nil?
      record_hash
    end

    def deleted?
      @deleted
    end

    private

    def new_record_hash
      Hash[MAP.map { |k, v| [k, send(v)] }].reject { |_, v| v.nil? }
    end

    def record_hash
      hash = new_record_hash
      hash['id'] = id
      hash['modified'] = modified.to_s
      hash['created'] = created.to_s
      hash
    end
  end
end
