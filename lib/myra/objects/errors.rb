# frozen_string_literal: true
module Myra
  class APIAuthError < StandardError
    def message
      'Could not authenticate with the API, check your credentials'
    end
  end

  class InvalidRequestTypeError < StandardError
    def message
      'Request method is invalid!'
    end
  end

  class ErrorResponse < StandardError
    def message
      'An error occured!'
    end
  end

  class CallError < StandardError
  end

  class DeserializationError < StandardError
    def message
      'Could not parse hash into ValueObject!'
    end
  end
end
