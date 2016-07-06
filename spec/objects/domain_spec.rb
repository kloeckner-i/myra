# frozen_string_literal: true
require 'spec_helper'

describe Myra::Domain do
  describe '.from_hash' do
    let(:hash) do
      {
        'id' => 16_409,
        'modified' => '2016-02-22T10:44:30+0100',
        'created' => '2016-02-22T10:44:30+0100',
        'name' => 'nova.at',
        'autoUpdate' => true,
        'maintenance' => false,
        'paused' => false,
        'owned' => false,
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

      expect(domain.modified.strftime('%Y-%m-%d')).to eql '2016-02-22'
      expect(domain.created.strftime('%H:%M:%S')).to eql '10:44:30'
    end
  end

  describe '#to_hash' do
    let(:domain) do
      domain = described_class.new(id: 42)
      domain.name = 'xkcd.com'
      domain
    end

    let(:new_domain) do
      domain = described_class.new
      domain.name = 'smbc-comics.com'
      domain.auto_update = true
      domain
    end

    it 'creates a hash representation for the domain' do
      hash = domain.to_hash
      expect(hash).to be_a Hash
      expect(hash['id']).to eql 42
      expect(hash['name']).to eql 'xkcd.com'

      # defaults
      %w(maintenance autoUpdate autoDns paused owned reversed).each do |field|
        expect(hash[field]).to be_falsey
      end
    end

    it 'creates a hash representation of a new domain w/o certain fields' do
      hash = new_domain.to_hash
      %w(id modified created).each do |field|
        expect(hash.key?(field)).to be_falsey
      end
    end
  end

  describe '#to_hash' do
    let(:domain) do
      domain = described_class.new(id: 42)
      domain.name = 'xkcd.com'
      domain
    end

    let(:new_domain) do
      domain = described_class.new
      domain.name = 'smbc-comics.com'
      domain.auto_update = true
      domain
    end

    it 'creates a hash representation for the domain' do
      hash = domain.to_hash
      expect(hash).to be_a Hash
      expect(hash['id']).to eql 42
      expect(hash['name']).to eql 'xkcd.com'

      # defaults
      %w(maintenance autoUpdate autoDns paused owned reversed).each do |field|
        expect(hash[field]).to be_falsey
      end
    end

    it 'creates a hash representation of a new domain w/o certain fields' do
      hash = new_domain.to_hash
      %w(id modified created).each do |field|
        expect(hash.key?(field)).to be_falsey
      end
    end
  end
end
