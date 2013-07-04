require "sepa/payments_initiation/pain00800104/regulatory_authority"
require "sepa/payments_initiation/pain00800104/structured_regulatory_reporting"

class Sepa::PaymentsInitiation::Pain00800104::RegulatoryReporting < Sepa::Base
  definition "Information needed due to regulatory and/or statutory requirements."
  attribute :debit_credit_reporting_indicator, "DbtCdtRptgInd"
  attribute :authority                       , "Authrty"      , Sepa::PaymentsInitiation::Pain00800104::RegulatoryAuthority
  attribute :details                         , "Dtls"         , Sepa::PaymentsInitiation::Pain00800104::StructuredRegulatoryReporting
end
