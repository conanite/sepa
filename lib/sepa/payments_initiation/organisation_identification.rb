require "sepa/payments_initiation/generic_organisation_identification_1"

class Sepa::PaymentsInitiation::OrganisationIdentification < Sepa::Base
  definition "Unique and unambiguous way to identify an organisation."
  attribute :other, "Othr", Sepa::PaymentsInitiation::GenericOrganisationIdentification1
end
