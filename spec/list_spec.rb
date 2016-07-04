# frozen_string_literal: true
require 'spec_helper'

describe Myra::List do
  let(:action) { described_class.new(:value_object) }

  describe 'fetching domains' do
    let(:value_object) { Myra::Domain }

    it 'retrieves domains as list of objects' do
      domains = action.perform
      expect(domains).to be_an Array
    end
  end
end
