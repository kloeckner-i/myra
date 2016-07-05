# frozen_string_literal: true
require 'spec_helper'

describe Myra::DnsRecord do
  describe '#from_hash' do
    let(:hash) do
      {
        'id' => 1,
        'modified' => '2013-12-11T11:35:00+0100',
        'created' => '2013-12-09T11:35:00+0100',
        'name' => 'subdomain.example.de',
        'value' => '127.0.0.1',
        'ttl' => 300,
        'recordType' => 'A',
        'alternativeCname' => 'subdomain-example-de.ax4z.com',
        'active' => true
      }
    end

    it 'parses a hash into a DnsRecord object' do
      record = described_class.from_hash(hash)
      expect(record.id).to eql 1
      expect(record.modified).to be_a DateTime
      expect(record.created).to be_a DateTime
      expect(record.name).to eql 'subdomain.example.de'
      expect(record.value).to eql '127.0.0.1'
      expect(record.ttl).to eql 300
      expect(record.type).to eql 'A'
      expect(record.alternative_cname).to eql 'subdomain-example-de.ax4z.com'
      expect(record.active?).to be_truthy
    end
  end
end
