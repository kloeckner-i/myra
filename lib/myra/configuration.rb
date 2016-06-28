# frozen_string_literal: true
module Myra
  class << self
    attr_writer :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end

  # Configuration provides the API credentials to MyraCloud
  class Configuration
    attr_accessor :api_key, :api_secret

    def initialize
      @api_key = ENV['MYRACLOUD_API_KEY']
      @api_secret = ENV['MYRACLOUD_API_SECRET']
    end
  end
end
