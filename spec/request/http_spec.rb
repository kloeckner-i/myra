# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request::HTTP do
  class ValueObject
    PATH = '/domains'
  end
  let(:req) { Myra::Request.new(ValueObject) }
  let(:http) { described_class.new req }
  let(:base_url) { 'https://api.myracloud.com' }
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
        stub_request(:get, url)
          .to_return(response)
        expect(http.response).to be_a Faraday::Response
      end
    end
  end
end
