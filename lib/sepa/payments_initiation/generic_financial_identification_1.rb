require 'sepa/payments_initiation/financial_identification_scheme_name_1_choice'

class Sepa::PaymentsInitiation::GenericFinancialIdentification1 < Sepa::Base
  definition "Unique identification of an agent, as assigned by an institution, using an identification scheme."
  attribute :identification, "Id"
  attribute :scheme_name   , "SchmeNm", Sepa::PaymentsInitiation::FinancialIdentificationSchemeName1Choice
  attribute :issuer        , "Issr"

  def empty?
    [identification, issuer].join.strip == '' && (scheme_name == nil || scheme_name.empty?)
  end
end
