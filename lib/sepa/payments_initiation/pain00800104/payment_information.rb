require "sepa/payments_initiation/pain00800104/direct_debit_transaction_information"

class Sepa::PaymentsInitiation::Pain00800104::PaymentInformation < Sepa::Base
  attribute :payment_information_identification  , "PmtInfId"
  attribute :payment_method                      , "PmtMtd"
  attribute :batch_booking                       , "BtchBookg"
  attribute :number_of_transactions              , "NbOfTxs"
  attribute :control_sum                         , "CtrlSum"
  attribute :payment_type_information            , "PmtTpInf"
  attribute :requested_collection_date           , "ReqdColltnDt", Date
  attribute :creditor                            , "Cdtr"        , Sepa::PaymentsInitiation::PartyIdentification
  attribute :creditor_account                    , "CdtrAcct"    , Sepa::PaymentsInitiation::CashAccount
  attribute :creditor_agent                      , "CdtrAgt"     , Sepa::PaymentsInitiation::BranchAndFinancialInstitutionIdentification
  attribute :creditor_agent_account              , "CdtrAgtAcct" , Sepa::PaymentsInitiation::CashAccount
  attribute :ultimate_creditor                   , "UltmtCdtr"   , Sepa::PaymentsInitiation::PartyIdentification
  attribute :charge_bearer                       , "ChrgBr"
  attribute :charges_account                     , "ChrgsAcct"   , Sepa::PaymentsInitiation::CashAccount
  attribute :charges_account_agent               , "ChrgsAcctAgt", Sepa::PaymentsInitiation::BranchAndFinancialInstitutionIdentification
  attribute :creditor_scheme_identification      , "CdtrSchmeId" , Sepa::PaymentsInitiation::PartyIdentification
  attribute :direct_debit_transaction_information, "DrctDbtTxInf", :[], Sepa::PaymentsInitiation::Pain00800104::DirectDebitTransactionInformation
end

