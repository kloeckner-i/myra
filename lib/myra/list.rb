# frozen_string_literal: true
module Myra
  class List
    attr_reader :value_object_class
    def initialize(value_object_class)
      @value_object_class = value_object_class
    end

    def perform
      # perform request for value object
      hash = evaluate Request.new(value_object_class).do
      hash['list'].map { |item| value_object_class.from_hash(item) }
    end

    private

    def evaluate(response)
      raise Myra::CallError unless response.status == 200
      hash = Oj.load(response.body)
      raise Myra::ErrorResponse if hash['error']
      hash
    end
  end
end
