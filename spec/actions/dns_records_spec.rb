# frozen_string_literal: true
require 'spec_helper'

describe Myra::DnsRecords do
  let(:url) { 'https://api.myracloud.com/en/rapi/dnsRecords' }
  describe '.list' do
    let(:domain) do
      domain = Myra::Domain.new id: 1
      domain.name = 'foo.com'
      domain
    end

    let(:request) do
      stub_request(:get, "#{url}/#{domain.name}").to_return(response)
    end

    let(:response) do
      {
        status: 200,
        body: load_json('successful_dns_records_response')
      }
    end

    it 'lists all dns records for the given domain' do
      records = described_class.list(domain)
      expect(request).to have_been_made.once
      expect(records).to be_an Array
      expect(records).to all(be_a(Myra::DnsRecord))
    end
  end
end
