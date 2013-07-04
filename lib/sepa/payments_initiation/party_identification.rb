require "sepa/payments_initiation/postal_address"
require "sepa/payments_initiation/party_choice_identification"

class Sepa::PaymentsInitiation::PartyIdentification < Sepa::Base
  definition "Set of elements used to identify a person or an organisation."
  attribute :name                , "Nm"
  attribute :postal_address      , "PstlAdr"  , Sepa::PaymentsInitiation::PostalAddress
  attribute :identification      , "Id"       , Sepa::PaymentsInitiation::PartyChoiceIdentification
  attribute :country_of_residence, "CtryOfRes"
  attribute :contact_details     , "CtctDtls" , Sepa::PaymentsInitiation::ContactDetails
end

