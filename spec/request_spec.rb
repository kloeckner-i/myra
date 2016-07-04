# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request do
  let(:request_class) { described_class }
  it 'is only viable for a valid value object class' do
    class Bar
    end

    expect do
      request_class.new(Bar)
    end.to raise_error(Myra::ValueObjectUndefinedError)
  end

  describe 'Request security features' do
    # values taken from MyraCloud api doc
    let(:date) { '2014-04-26CET13:04:00+0100' }
    let(:api_secret) { '6b3a71954faf11e4b898001517fa8424' }
    let(:expected_signing_key) do
      '1c2a270750de0cc1b8c3522494abd9a04e0b7801be6ece02755fa7bc9f8f5467'
    end
  end
end
