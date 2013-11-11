require "sepa/payments_initiation/person_identification_scheme_name_1_choice"

class Sepa::PaymentsInitiation::GenericPersonIdentification1 < Sepa::Base
  definition "Unique identification of a person, as assigned by an institution, using an identification scheme."
  attribute :identification, "Id"
  attribute :scheme_name   , "SchmeNm", Sepa::PaymentsInitiation::PersonIdentificationSchemeName1Choice
  attribute :issuer        , "Issr"
end
