# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request do
  describe '#signing_string' do
    it 'generates a signing string from the values given' do
      request = described_class.new(uri: '/en/rapi/fooo')
      expected = 'd41d8cd98f00b204e9800998ecf8427e' \
                 '#GET' \
                 '#/en/rapi/fooo' \
                 '#application/json' \
                 "##{request.date}"
      expect(request.signing_string).to eql expected
    end
  end

  describe '#type' do
    let(:request) { described_class.new(uri: '/foo') }
    it 'is a GET request by default' do
      expect(request.type).to eql :get
    end

    it 'is able to be set to other types' do
      request.type = :options
      expect(request.type).to eql :options
    end

    it 'cannot be set to bogus types' do
      expect do
        request.type = :bogus_method
      end.to raise_error(Myra::InvalidRequestTypeError)
    end
  end
end
