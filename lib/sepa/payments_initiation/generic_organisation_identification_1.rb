require "sepa/payments_initiation/organisation_identification_scheme_name_1_choice"

class Sepa::PaymentsInitiation::GenericOrganisationIdentification1 < Sepa::Base
  definition "Unique identification of an organisation, as assigned by an institution, using an identification scheme."
  attribute :identification, "Id"
  attribute :scheme_name   , "SchmeNm", Sepa::PaymentsInitiation::OrganisationIdentificationSchemeName1Choice
  attribute :issuer        , "Issr"
end
