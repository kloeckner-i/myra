# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request::HTTP do
  let(:request) { Myra::Request.new path: path }
  let(:http) { described_class.new request }
  let(:base_url) { 'https://api.myracloud.com/en/rapi' }
  let(:url) { "#{base_url}#{path}"}

  describe '#response', :focus do
    describe '#get' do
      let(:path) { '/domains' }
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
        stub_request = stub_request(:get, url).with(headers: headers).to_return(response)
        expect(http.response).to be_a Faraday::Response
        expect(stub_request).to have_been_made.once
      end
    end
  end
end
