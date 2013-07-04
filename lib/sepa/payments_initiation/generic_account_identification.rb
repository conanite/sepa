require "sepa/payments_initiation/account_scheme_name_choice"

class Sepa::PaymentsInitiation::GenericAccountIdentification < Sepa::Base
  definition "Unique identification of an account, as assigned by the account servicer, using an identification scheme."
  attribute :identification, "Id"
  attribute :scheme_name   , "SchmeNm", Sepa::PaymentsInitiation::AccountSchemeNameChoice
  attribute :issuer        , "Issr"
end
