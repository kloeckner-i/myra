# frozen_string_literal: true
require 'spec_helper'

describe Myra::Domains do
  let(:url) { 'https://api.myracloud.com/en/rapi/domains' }
  describe '#list' do
    let(:response) do
      {
        status: 200,
        body: load_json('successful_domains_response')
      }
    end

    let!(:stub) do
      stub_request(:get, url).to_return(response)
    end

    it 'retrieves domains as list of objects' do
      domains = described_class.list
      expect(stub).to have_been_made.once
      expect(domains).to be_an Array
      expect(domains).to all(be_a(Myra::Domain))
      expect(domains.last.name).to eql 'nova.at'
      expect(domains.first.name).to eql 'foobar.rocks'
    end
  end

  describe '#create' do
    let!(:request) do
      stub_request(:put, url).with(
        headers: {
          'Date' => /.*/,
          'Authorization' => /MYRA\s.*/
        },
        body: {
          'name' => 'example.com',
          'autoUpdate' => false,
          'autoDns' => false,
          'maintenance' => false,
          'owned' => false,
          'paused' => false,
          'reversed' => false
        }
      ).to_return response
    end

    let(:response) do
      {
        status: 200,
        body: %(
          {
            "error": false,
            "violationList": [],
            "targetObject": [{
              "id": 1,
              "modified": "2013-12-13T11:30:00+0100",
              "created": "2013-12-13T11:30:00+0100",
              "name": "example.com",
              "autoUpdate": false,
              "owned": true,
              "maintenance": false
            }]
          }
        ).strip
      }
    end

    it 'creates a new domain successfully' do
      domain = Myra::Domain.new
      domain.name = 'example.com'
      domain.auto_update = false
      domain.auto_dns = false

      domain = described_class.create(domain)
      expect(request).to have_been_made.once
      expect(domain.id).to eql 1
    end
  end
end
