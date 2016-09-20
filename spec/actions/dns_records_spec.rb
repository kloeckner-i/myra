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
    stub_request(method, url).with(
      headers: authorized_headers,
      body: request_body
    ).to_return(response)
  end
  let(:request_body) { '' }
  describe '.list' do
    let(:url) { 'https://api.myracloud.com/en/rapi/dnsRecords/foo.com/1' }
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
    let(:request_body) do
      {
        'name' => 'bar.foo.com',
        'value' => '127.0.0.1',
        'ttl' => 300,
        'recordType' => 'CNAME',
        'active' => true
      }
    end

    let(:response) do
      {
        status: 200,
        body: load_json('successful_dns_record_creation')
      }
    end

    it 'creates a new record sucessfully' do
      record = Myra::DnsRecord.new
      record.name = 'bar'
      record.type = Myra::DnsRecord::Type::CNAME
      record.value = '127.0.0.1'
      new_record = described_class.create(record, domain)
      expect(new_record).to be_a Myra::DnsRecord
      expect(new_record.id).to_not be_nil
    end
  end

  describe '.edit' do
    let(:method) { :post }
    let(:request_body) do
      {
        'value' => '128.0.0.2',
        'name' => 'foobar.foo.com',
        'recordType' => 'A',
        'ttl' => 300,
        'created' => '',
        'active' => true,
        # mandatory in update
        'id' => 3,
        'modified' => '2013-12-09T11:30:00+01:00'
      }
    end
    let(:response) do
      {
        status: 200,
        body: load_json('successful_dns_record_update')
      }
    end

    it 'updates a record appropriately' do
      record = Myra::DnsRecord.new(id: 3)
      record.modified = DateTime.parse('2013-12-09T11:30:00+0100')
      record.name = 'foobar.foo.com'
      record.value = '128.0.0.2'
      updated = described_class.update(domain, record)
      expect(request).to have_been_made.once
      expect(updated).to be_a Myra::DnsRecord
    end
  end

  describe '.delete' do
    let(:method) { :delete }
    let(:request_body) do
      {
        'id' => 1,
        'modified' => '2013-12-09T11:30:00+01:00'
      }
    end
    let(:response) do
      {
        status: 200,
        body: load_json('successful_dns_record_creation')
      }
    end

    it 'deletes a record' do
      record = Myra::DnsRecord.new id: 1
      record.modified = DateTime.parse '2013-12-09T11:30:00+01:00'
      deleted_record = described_class.delete(domain, record)
      expect(request).to have_been_made.once
      expect(deleted_record).to be_a Myra::DnsRecord
      expect(deleted_record.deleted?).to be_truthy
    end
  end
end
