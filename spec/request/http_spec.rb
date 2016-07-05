# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request::HTTP do
  let(:req) { Myra::Request.new(uri: path) }
  let(:http) { described_class.new req }
  let(:base_url) { 'https://api.myracloud.com' }
  let(:path) { '/domains' }
  let(:url) { "#{base_url}#{path}"}

  describe '#response', :focus do
    describe '#get' do
      let(:path) { '/en/rapi/domains' }
      let(:headers) do
        {
          'Authorization': /^MYRA\s.*/,
          'Content-Type': 'application/json',
          'Date': /.*/
        }
      end
      let(:response) do
        {
          status: 200,
          body: '{}'
        }
      end
      it 'makes a get request against the endpoint' do
        req = stub_request(:get, url)
          .to_return(response)
        expect(http.response).to be_a Faraday::Response
        expect(req).to have_been_made.once
      end
    end
  end
end
