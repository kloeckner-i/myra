# frozen_string_literal: true
module Myra
  class ValueObjectUndefinedError < StandardError
    def message
      'Object does not respond to PATH and cannot be used as value object'
    end
  end
end
