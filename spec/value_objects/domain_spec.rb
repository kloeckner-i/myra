# frozen_string_literal: true
require 'spec_helper'

describe Myra::Domain do
  describe '#from_hash' do
    let(:hash) do
      {
        'objectType' => 'DomainVO',
        'id' => 16_409,
        'modified' => '2016-02-22T10:44:30+0100',
        'created' => '2016-02-22T10:44:30+0100',
        'name' => 'nova.at',
        'autoUpdate' => true,
        'maintenance' => false,
        'paused' => false,
        'owned' => false,
        'dnsRecords' => [],
        'reversed' => false
      }
    end

    it 'parses a hash into a domain object' do
      domain = described_class.from_hash(hash)

      expect(domain.id).to eql 16_409
      expect(domain.name).to eql 'nova.at'
      expect(domain.auto_update?).to be_truthy
      expect(domain.maintenance?).to be_falsey
      expect(domain.paused?).to be_falsey
      expect(domain.reversed?).to be_falsey
      expect(domain.owned?).to be_falsey
      expect(domain.dns_records).to be_empty
    end
  end
end
