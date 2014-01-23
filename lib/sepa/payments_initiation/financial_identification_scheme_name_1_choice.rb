class Sepa::PaymentsInitiation::FinancialIdentificationSchemeName1Choice < Sepa::Base
  code_or_proprietary

  def empty?
    [code, proprietary].join.strip == ""
  end
end
