class Sepa::PaymentsInitiation::Pain00800104::StructuredRegulatoryReporting < Sepa::Base
  definition "Set of elements used to provide details on the regulatory reporting information."
  attribute :type       , "Tp"
  attribute :date       , "Dt"  , Date
  attribute :country    , "Ctry"
  attribute :code       , "Cd"
  attribute :amount     , "Amt"
  attribute :information, :[]
end
