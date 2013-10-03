require 'sepa/payments_initiation/pain00800104/mandate_related_information'

class Sepa::PaymentsInitiation::Pain00800104::DirectDebitTransaction < Sepa::Base
  definition "Provides information specific to the direct debit mandate."

  attribute :mandate_related_information       , "MndtRltdInf"      , Sepa::PaymentsInitiation::Pain00800104::MandateRelatedInformation
end
