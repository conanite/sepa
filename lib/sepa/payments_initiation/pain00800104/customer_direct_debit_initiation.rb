require "sepa/payments_initiation/pain00800104/group_header"
require "sepa/payments_initiation/pain00800104/payment_information"

class Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation < Sepa::Base
  attribute :group_header         , "GrpHdr", Sepa::PaymentsInitiation::Pain00800104::GroupHeader
  attribute :payment_information  , "PmtInf", :[], Sepa::PaymentsInitiation::Pain00800104::PaymentInformation

  def generate_xml opts
    pain_008_001_version = opts[:pain_008_001_version]

    unless %w{ 02 04 }.include?(pain_008_001_version)
      raise "unknown SEPA pain-008-001 version: #{pain_008_001_version.inspect} - use '04' or '02'"
    end

    doc_props = {
      :xmlns                 => "urn:iso:std:iso:20022:tech:xsd:pain.008.001.#{pain_008_001_version}",
      :"xmlns:xsi"           => "http://www.w3.org/2001/XMLSchema-instance",
      :"xsi:schemaLocation"  => "urn:iso:std:iso:20022:tech:xsd:pain.008.001.#{pain_008_001_version} pain.008.001.#{pain_008_001_version}.xsd"
    }

    builder = Builder::XmlMarkup.new(:indent => 2)
    builder.instruct!
    builder.Document(doc_props) {
      builder.CstmrDrctDbtInitn {
        self.to_xml builder
      }
    }
  end
end
