# frozen_string_literal: true
require 'spec_helper'

describe Myra::Request::Signature do
  # Date taken from documentation example
  let(:date) { '2014-04-26CET13:04:00+0100' }
  # Api Secret taken from documentation example
  let(:api_secret) { '6b3a71954faf11e4b898001517fa8424' }

  let(:signature) { described_class.new(date: date, secret: api_secret) }

  it 'generates a $dateKey' do
    dk = '1c2a270750de0cc1b8c3522494abd9a04e0b7801be6ece02755fa7bc9f8f5467'
    expect(signature.date_key).to eql dk
  end

  it 'generates a $signingKey' do
    # signing key from documentation example
    sk = '3744ae9c3d3f87c3ce90a99957f9f054266ef9386fc909e2a24a7031c7571ffd'
    expect(signature.signing_key).to eql sk
  end

  it 'generates a final signature from a signing_string' do
    signing_string = [
      'd41d8cd98f00b204e9800998ecf8427e',
      'GET',
      '/en/rapi/cacheSetting/www.example.de',
      'application/json',
      date
    ].join('#')

    # expected signature from documentation example
    sig = '7OXCjTTssU9DD/mkbhyp5Syup0ufUm1YOWUj66hsxmTc'\
          'tVordMIVLS30pi7CSp1hC7EcZ2q1hvpXJMMNkvAncw=='
    expect(signature.for(signing_string)).to eql sig
  end
end
