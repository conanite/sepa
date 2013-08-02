require "sepa/payments_initiation/cash_account"
require "sepa/payments_initiation/party_identification"
require "sepa/payments_initiation/pain00800104/payment_identification"
require "sepa/payments_initiation/pain00800104/payment_type_information"
require "sepa/payments_initiation/pain00800104/direct_debit_transaction"
require "sepa/payments_initiation/pain00800104/purpose_choice"
require "sepa/payments_initiation/pain00800104/regulatory_reporting"

class Sepa::PaymentsInitiation::Pain00800104::DirectDebitTransactionInformation < Sepa::Base
  definition "Provides information on the individual transaction(s) included in the message."
  attribute :payment_identification        , "PmtId"          , Sepa::PaymentsInitiation::Pain00800104::PaymentIdentification
  attribute :payment_type_information      , "PmtTpInf"       , Sepa::PaymentsInitiation::Pain00800104::PaymentTypeInformation
  attribute :instructed_amount             , "InstdAmt"       , :string, nil, :attributes => { :Ccy => :instructed_amount_currency }
  attribute :charge_bearer                 , "ChrgBr"
  attribute :direct_debit_transation       , "DrctDbtTx"      , Sepa::PaymentsInitiation::Pain00800104::DirectDebitTransaction
  attribute :ultimate_creditor             , "UltmtCdtr"      , Sepa::PaymentsInitiation::PartyIdentification
  attribute :debtor_agent                  , "DbtrAgt"        , Sepa::PaymentsInitiation::BranchAndFinancialInstitutionIdentification
  attribute :debtor_agent_account          , "DbtrAgtAcct"    , Sepa::PaymentsInitiation::CashAccount
  attribute :debtor                        , "Dbtr"           , Sepa::PaymentsInitiation::PartyIdentification
  attribute :debtor_account                , "DbtrAcct"       , Sepa::PaymentsInitiation::CashAccount
  attribute :ultimate_debtor               , "UltmtDbtr"      , Sepa::PaymentsInitiation::PartyIdentification
  attribute :instruction_for_creditor_agent, "InstrForCdtrAgt"
  attribute :purpose                       , "Purp"           , Sepa::PaymentsInitiation::Pain00800104::PurposeChoice
  attribute :regulatory_reporting          , "RgltryRptg"     , :[], Sepa::PaymentsInitiation::Pain00800104::RegulatoryReporting

  attr_accessor :instructed_amount_currency
end
