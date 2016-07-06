# frozen_string_literal: true
module JSONHelper
  def load_json(fixture_name)
    File.read("spec/fixtures/#{fixture_name}.json")
  end
end
