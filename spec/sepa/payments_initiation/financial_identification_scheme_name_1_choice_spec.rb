# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sepa::PaymentsInitiation::FinancialIdentificationSchemeName1Choice do
  it "should be empty by default" do
    Sepa::PaymentsInitiation::FinancialIdentificationSchemeName1Choice.new({ }).should be_empty
  end
end
