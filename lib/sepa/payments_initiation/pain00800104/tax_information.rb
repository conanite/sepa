require "sepa/payments_initiation/pain00800104/tax_party"

class Sepa::PaymentsInitiation::Pain00800104::TaxInformation < Sepa::Base
  definition "Details about tax paid, or to be paid, to the government in accordance with the law, including pre-defined parameters such as thresholds and type of account."
  attribute :creditor, "Cdtr", Sepa::PaymentsInitiation::Pain00800104::TaxParty
  attribute :debtor, "Dbtr", Sepa::PaymentsInitiation::Pain00800104::TaxParty
end
