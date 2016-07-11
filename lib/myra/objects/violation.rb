# frozen_string_literal: true
module Myra
  class Violation
    attr_reader :property, :message

    def initialize(property, message)
      @property = property
      @message = message
    end

    def self.from_hash(violation)
      new(violation['propertyPath'], violation['message'])
    end
  end
end
