require "sepa/payments_initiation/postal_address"

class Sepa::PaymentsInitiation::FinancialInstitutionIdentification < Sepa::Base
  definition "Unique and unambiguous identification of a financial institution, as assigned under an internationally recognised or proprietary identification scheme."
  attribute :bic_fi, "BICFI"
  attribute :bic,    "BIC"
  attribute :name,   "Nm"
  attribute :postal_address, "PstlAdr", Sepa::PaymentsInitiation::PostalAddress

end
