# frozen_string_literal: true
require 'spec_helper'

describe Myra::List do
  let(:action) { described_class.new(value_object) }

  describe 'fetching domains' do
    let(:value_object) { Myra::Domain }
    let(:response) do
      {
        status: 200,
        body: body
      }
    end

    let(:body) do
      <<-JSON
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
    end

    describe '#perform' do
      it 'retrieves domains as list of objects' do
        stub_request(:get, 'https://api.myracloud.com/en/rapi/domains')
          .to_return response
        domains = action.perform
        expect(domains).to be_an Array
        domains.each { |domain| expect(domain).to be_a Myra::Domain }
      end

      it 'throws an error if the response contains an error' do
        stub_request(:get, 'https://api.myracloud.com/en/rapi/domains')
          .to_return response.merge(body: '{"error":true}')
        expect { action.perform }.to raise_error(Myra::ErrorResponse)
      end
    end
  end
end
