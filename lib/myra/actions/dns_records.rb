# frozen_string_literal: true
module Myra
  module DnsRecords
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

    def self.update(_record, _domain)
    end

    def self.delete(_record, _domain)
    end

    def self.path(domain)
      PATH.gsub('{domain}', domain.name)
    end

    def self.handle(request)
      response = request.do
      raise APIAuthError if response.status == 403
      values = Oj.load(response.body)
      errors values
    end

    def self.errors(values)
      return values unless values['error']
      violations = values['violationList'].map do |v|
        Myra::Violation.from_hash v
      end
      raise APIActionError.new(violations)
    end

    def self.normalize_domain_name(record, domain)
      return record if record.name.include?(domain.name)
      record.name = "#{record.name}.#{domain.name}"
      record
    end

    private_class_method :handle, :errors, :path, :normalize_domain_name
  end
end
