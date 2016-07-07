# frozen_string_literal: true
require 'spec_helper'

describe Myra::Violation do
  let(:violation_hash) do
    {
      'propertyPath' => 'domain',
      'message' => 'Please enter a domain'
    }
  end

  describe '.from_hash' do
    it 'parses a hash into a violation' do
      violation = described_class.from_hash(violation_hash)
      expect(violation.message).to eql('Please enter a domain')
      expect(violation.property).to eql('domain')
    end
  end
end
