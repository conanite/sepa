require "sepa/payments_initiation/generic_person_identification_1"

class Sepa::PaymentsInitiation::PrivateIdentification < Sepa::Base
  definition "Unique and unambiguous identification of a person, eg, passport."
  attribute :other, "Othr", Sepa::PaymentsInitiation::GenericPersonIdentification1
end
