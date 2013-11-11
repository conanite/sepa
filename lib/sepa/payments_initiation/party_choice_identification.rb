require "sepa/payments_initiation/organisation_identification"
require "sepa/payments_initiation/private_identification"

class Sepa::PaymentsInitiation::PartyChoiceIdentification < Sepa::Base
  definition "Unique and unambiguous identification of a party."
  attribute :organisation_identification, "OrgId" , Sepa::PaymentsInitiation::OrganisationIdentification
  attribute :private_identification     , "PrvtId", Sepa::PaymentsInitiation::PrivateIdentification
end
