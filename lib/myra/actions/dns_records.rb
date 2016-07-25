# frozen_string_literal: true
module Myra
  module DnsRecords
    extend RequestHandler
    extend DomainHandler
    PATH = '/dnsRecords/{domain}'

    def self.list(domain)
      values = handle Request.new(path: path(domain))
      values['list'].map { |record| DnsRecord.from_hash(record) }
    end

    def self.create(record, domain)
      record = normalize_domain_name(record, domain)
      request = Request.new(path: path(domain), type: :put)
      request.payload = Oj.dump(record.to_hash)
      value = handle request
      DnsRecord.from_hash(value['targetObject'].first)
    end

    def self.update(domain, record)
      record = normalize_domain_name(record, domain)
      request = Request.new(path: path(domain), type: :post)
      request.payload = Oj.dump(record.to_hash)
      value = handle request
      DnsRecord.from_hash(value['targetObject'].first)
    end

    def self.delete(domain, record)
      r = normalize_domain_name(record, domain)
      request = Request.new(path: path(domain), type: :delete)
      keys = %w(modified id)
      request.payload = Oj.dump(r.to_hash.select { |k, _| keys.include? k })
      value = handle request
      deleted_record = DnsRecord.from_hash(value['targetObject'].first)
      deleted_record.deleted = true
      deleted_record
    end
  end
end
