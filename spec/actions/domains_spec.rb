# frozen_string_literal: true
require 'spec_helper'

describe Myra::Domains do
  let(:path) { 'https://api.myracloud.com/en/rapi/domains' }
  describe '#list' do
    let(:response) do
      {
        status: 200,
        body: <<-JSON
      {
        "error": false,
        "list": [{
          "objectType": "DomainVO",
          "id": 16551,
          "modified": "2016-06-23T13:51:24+0200",
          "created": "2016-06-23T13:51:24+0200",
          "name": "foobar.rocks",
          "autoUpdate": true,
          "maintenance": false,
          "paused": false,
          "owned": true,
          "dnsRecords": [],
          "reversed": false
        }, {
          "objectType": "DomainVO",
          "id": 16407,
          "modified": "2016-02-22T10:20:38+0100",
          "created": "2016-02-22T10:20:38+0100",
          "name": "foobbbra.com",
          "autoUpdate": true,
          "maintenance": false,
          "paused": false,
          "owned": false,
          "dnsRecords": [],
          "reversed": false
        }, {
          "objectType": "DomainVO",
          "id": 16409,
          "modified": "2016-02-22T10:44:30+0100",
          "created": "2016-02-22T10:44:30+0100",
          "name": "nova.at",
          "autoUpdate": true,
          "maintenance": false,
          "paused": false,
          "owned": false,
          "dnsRecords": [],
          "reversed": false
        }],
        "page": 1,
        "count": 11,
        "pageSize": 50
      }
      JSON
      }
    end

    let!(:stub) do
      stub_request(:get, path).to_return(response)
    end

    it 'retrieves domains as list of objects' do
      domains = subject.list
      expect(stub).to have_been_made.once
      expect(domains).to be_an Array
      domains.each { |domain| expect(domain).to be_a Myra::Domain }
      expect(domains.last.name).to eql 'nova.at'
      expect(domains.first.name).to eql 'foobar.rocks'
    end
  end
end
