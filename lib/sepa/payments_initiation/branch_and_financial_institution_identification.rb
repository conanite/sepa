require "sepa/payments_initiation/financial_institution_identification"

class Sepa::PaymentsInitiation::BranchAndFinancialInstitutionIdentification < Sepa::Base
  definition "Set of elements used to uniquely and unambiguously identify a financial institution or a branch of a financial institution."
  attribute :financial_institution_identification, "FinInstnId", Sepa::PaymentsInitiation::FinancialInstitutionIdentification
end
