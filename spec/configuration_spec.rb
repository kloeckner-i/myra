# frozen_string_literal: true
require 'spec_helper'

describe Myra do
  describe '#configure' do
    before do
      Myra.configure do |config|
        config.api_key = 'foo'
        config.api_secret = 'bar'
      end
    end

    it 'creates a configuration with the values set' do
      expect(Myra.configuration.api_key).to eql 'foo'
      expect(Myra.configuration.api_secret).to eql 'bar'
    end
  end

  describe '#configuration' do
    before do
      ENV['MYRACLOUD_API_KEY'] = 'best_api_key_to_use_ever'
      ENV['MYRACLOUD_API_SECRET'] = 'most_secret_api_secret_ever'
      Myra.reset_configuration!
    end

    after do
      ENV.delete('MYRACLOUD_API_KEY')
      ENV.delete('MYRACLOUD_API_SECRET')
    end

    it 'has a default API Key from environment' do
      expect(Myra.configuration.api_key).to eql 'best_api_key_to_use_ever'
    end

    it 'has a default API secret from environment' do
      expect(Myra.configuration.api_secret).to eql 'most_secret_api_secret_ever'
    end
  end

  describe Myra::Configuration do
    let(:config) { described_class.new }
    before do
      ENV['MYRACLOUD_API_KEY'] = 'best_api_key_to_use_ever'
      ENV['MYRACLOUD_API_SECRET'] = 'most_secret_api_secret_ever'
    end

    after do
      ENV.delete('MYRACLOUD_API_KEY')
      ENV.delete('MYRACLOUD_API_SECRET')
    end

    it 'gets initialized with env variables' do
      expect(config.api_key).to eql 'best_api_key_to_use_ever'
      expect(config.api_secret).to eql 'most_secret_api_secret_ever'
    end
  end
end
