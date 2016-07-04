# frozen_string_literal: true
module Myra
  class ValueObjectUndefinedError < StandardError
    def message
      'Object does not respond to PATH and cannot be used as value object'
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
end
