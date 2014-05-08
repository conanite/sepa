require 'sepa/payments_initiation/pain00800104/tax_authorisation'

class Sepa::PaymentsInitiation::Pain00800104::TaxParty < Sepa::Base
  definition "Party to the transaction to which the tax applies."
  attribute :tax_identification, "TaxId"
  attribute :registration_identification, "RegnId"
  attribute :tax_type, "TaxTp"
  attribute :authorisation, "Authstn", Sepa::PaymentsInitiation::Pain00800104::TaxAuthorisation
end
