require "sepa/payments_initiation/account_identification_choice"
require "sepa/payments_initiation/cash_account_type_choice"

class Sepa::PaymentsInitiation::CashAccount < Sepa::Base
  attribute :identification, "Id", Sepa::PaymentsInitiation::AccountIdentificationChoice
  attribute :type, "Tp", Sepa::PaymentsInitiation::CashAccountTypeChoice
  attribute :currency, "Ccy"
  attribute :name, "Nm"
end
