require "sepa/payments_initiation/pain00800104/group_header"
require "sepa/payments_initiation/pain00800104/payment_information"

class Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation < Sepa::Base
  attribute :group_header         , "GrpHdr", Sepa::PaymentsInitiation::Pain00800104::GroupHeader
  attribute :payment_information  , "PmtInf", :[], Sepa::PaymentsInitiation::Pain00800104::PaymentInformation

  def generate_xml
    builder = Builder::XmlMarkup.new(:indent => 2)
    builder.instruct!
    builder.Document(:xmlns=>"urn:iso:std:iso:20022:tech:xsd:pain.008.001.04", :"xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", :"xsi:schemaLocation"=>"urn:iso:std:iso:20022:tech:xsd:pain.008.001.04 pain.008.001.04.xsd") {
      builder.CstmrDrctDbtInitn {
        self.to_xml builder
      }
    }
  end
end
