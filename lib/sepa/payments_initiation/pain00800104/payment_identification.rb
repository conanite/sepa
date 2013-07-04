class Sepa::PaymentsInitiation::Pain00800104::PaymentIdentification < Sepa::Base
  definition "Set of elements used to reference a payment instruction."
  attribute :instruction_identification, "InstrId"
  attribute :end_to_end_identification, "EndToEndId"
end