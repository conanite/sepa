require "sepa/payments_initiation/pain00800104/service_level_choice"
require "sepa/payments_initiation/local_instrument_choice"

class Sepa::PaymentsInitiation::Pain00800104::PaymentTypeInformation < Sepa::Base
  definition "Set of elements used to further specify the type of transaction."
  attribute :instruction_priority, "InstrPrty"
  attribute :service_level       , "SvcLvl", Sepa::PaymentsInitiation::Pain00800104::ServiceLevelChoice
  attribute :local_instrument    , "LclInstrm", Sepa::PaymentsInitiation::LocalInstrumentChoice
  attribute :sequence_type       , "SeqTp"
  attribute :category_purpose    , "CtgyPurp", Sepa::PaymentsInitiation::CategoryPurposeChoice
end
