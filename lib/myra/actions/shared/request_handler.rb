# frozen_string_literal: true
module Myra
  module RequestHandler
    def handle(request)
      response = request.do
      raise APIAuthError if response.status == 403
      values = Oj.load(response.body)
      errors values
    end

    def errors(values)
      return values unless values['error']
      violations = values['violationList'].map do |v|
        Myra::Violation.from_hash v
      end
      raise APIActionError.new(violations)
    end
  end
end
