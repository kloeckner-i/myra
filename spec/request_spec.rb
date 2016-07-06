# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request do
  let(:request) { described_class.new(path: '/foo') }
  describe '#signing_string' do
    it 'generates a signing string from the values given' do
      expected = 'd41d8cd98f00b204e9800998ecf8427e' \
                 '#GET' \
                 '#/en/rapi/foo' \
                 '#application/json' \
                 "##{request.date}"
      expect(request.signing_string).to eql expected
    end
  end

  describe '#type' do
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
