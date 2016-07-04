# frozen_string_literal: true
module Myra
  class List
    attr_reader :value_object_class
    def initialize(value_object_class)
      @value_object_class = value_object_class
    end

    def perform
      # perform request for value object
      []
    end
  end
end
