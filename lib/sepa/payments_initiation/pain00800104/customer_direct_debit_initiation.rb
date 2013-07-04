require "sepa/payments_initiation/pain00800104/group_header"
require "sepa/payments_initiation/pain00800104/payment_information"

class Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation < Sepa::Base
  attribute :group_header         , "GrpHdr", Sepa::PaymentsInitiation::Pain00800104::GroupHeader
  attribute :payment_information  , "PmtInf", :[], Sepa::PaymentsInitiation::Pain00800104::PaymentInformation
end
