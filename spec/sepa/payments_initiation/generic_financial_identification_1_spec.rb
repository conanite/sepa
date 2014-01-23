# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sepa::PaymentsInitiation::GenericFinancialIdentification1 do
  it "should be empty by default" do
    Sepa::PaymentsInitiation::GenericFinancialIdentification1.new({ }).should be_empty
  end
end
