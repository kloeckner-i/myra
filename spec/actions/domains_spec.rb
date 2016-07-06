# frozen_string_literal: true
require 'spec_helper'

describe Myra::Domains do
  let(:path) { 'https://api.myracloud.com/en/rapi/domains' }
  describe '#list' do
    let(:response) do
      {
        status: 200,
        body: load_json('successful_domains_response')
      }
    end

    let!(:stub) do
      stub_request(:get, path).to_return(response)
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
end
