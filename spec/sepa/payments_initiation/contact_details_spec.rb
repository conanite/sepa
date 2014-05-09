# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sepa::PaymentsInitiation::ContactDetails do
  it "should be empty by default" do
    Sepa::PaymentsInitiation::ContactDetails.new({ }).should be_empty
  end

  it "should not generate an empty 'Nm' tag" do
    contact_details = Sepa::PaymentsInitiation::ContactDetails.new({ :phone_number => "12345" })
    builder = Builder::XmlMarkup.new(:indent => 2)
    xml = builder.Document() {
      contact_details.to_xml builder
    }
    expect(xml).to eq "<Document>\n  <PhneNb>12345</PhneNb>\n</Document>\n"
  end
end
