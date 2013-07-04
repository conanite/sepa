require "sepa/payments_initiation/generic_account_identification"

class Sepa::PaymentsInitiation::AccountIdentificationChoice < Sepa::Base
  definition "Specifies the unique identification of an account as assigned by the account servicer."
  attribute :iban, "IBAN"
  attribute :other, "Othr", Sepa::PaymentsInitiation::GenericAccountIdentification
end
