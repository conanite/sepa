class Sepa::PaymentsInitiation::Pain00800104::MandateRelatedInformation < Sepa::Base
  definition "Provides further details of the direct debit mandate signed between the creditor and the debtor."

  attribute :mandate_identification, "MndtId"   , :string
  attribute :date_of_signature     , "DtOfSgntr", Date
end
