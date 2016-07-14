# frozen_string_literal: true
require 'spec_helper'

describe Myra::DnsRecords do
  let(:url) { "https://api.myracloud.com/en/rapi/dnsRecords/#{domain.name}" }
  let(:authorized_headers) do
    {
      'Date' => /.*/,
      'Authorization' => /MYRA\s.*/,
      'Content-Type' => 'application/json'
    }
  end
  let(:domain) do
    domain = Myra::Domain.new id: 1
    domain.name = 'foo.com'
    domain
  end
  let!(:request) do
    stub_request(method, url).to_return(response)
  end
  describe '.list' do
    let(:method) { :get }
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

  describe '.create' do
    let(:method) { :put }
    let!(:request) do
      stub_request(method, url).with(
        headers: authorized_headers,
        body: {
          'name' => 'bar.foo.com',
          'value' => '127.0.0.1',
          'ttl' => 300,
          'recordType' => 'CNAME',
          'active' => true
        }
      ).to_return response
    end

    let(:response) do
      {
        status: 200,
        body: load_json('successful_dns_record_creation')
      }
    end

    it 'should create a new record sucessfully' do
      record = Myra::DnsRecord.new
      record.name = 'bar'
      record.type = Myra::DnsRecord::Type::CNAME
      record.value = '127.0.0.1'
      new_record = described_class.create(record, domain)
      expect(new_record).to be_a Myra::DnsRecord
      expect(new_record.id).to_not be_nil
    end
  end
end
