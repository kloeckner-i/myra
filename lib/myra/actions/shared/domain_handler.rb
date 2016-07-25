# frozen_string_literal: true
module Myra
  module DomainHandler
    def path(domain)
      const_get('PATH').gsub('{domain}', domain.name)
    end

    def normalize_domain_name(record, domain)
      return record if record.name.nil?
      return record if record.name.include?(domain.name)
      record.name = "#{record.name}.#{domain.name}"
      record
    end
  end
end
