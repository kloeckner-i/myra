# frozen_string_literal: true
module Myra
  class APIAuthError < StandardError
    def message
      'Could not authenticate with the API, check your credentials'
    end
  end

  class APIActionError < StandardError
    attr_reader :violations

    def initialize(
      violations,
      message = 'An error occured while processing your request'
    )
      super(message)
      @violations = violations
    end
  end

  class InvalidRequestTypeError < StandardError
  end
end
