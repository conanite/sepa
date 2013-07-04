
require "builder"
require "aduki"
require "sepa/version"
require "sepa/base"
require "sepa/payments_initiation"
require "sepa/direct_debit_order"

module Sepa
  def self.to_xml customer_direct_debit_initiation
    builder = Builder::XmlMarkup.new(:indent => 2)
    builder.instruct!
    builder.Document(:xmlns=>"urn:iso:std:iso:20022:tech:xsd:pain.008.001.04", :"xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", :"xsi:schemaLocation"=>"urn:iso:std:iso:20022:tech:xsd:pain.008.001.04 pain.008.001.04.xsd") {
      builder.CstmrDrctDbtInitn {
        customer_direct_debit_initiation.to_xml builder
      }
    }
  end

  def self.build attrs
    Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation.new attrs
  end
end
