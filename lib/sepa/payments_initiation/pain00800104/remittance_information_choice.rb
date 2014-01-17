class Sepa::PaymentsInitiation::Pain00800104::RemittanceInformationChoice < Sepa::Base
  attribute :unstructured_remittance_information , "Ustrd"
  # don't think this is commonly used; would probably need a class
  attribute :structured_remittance_information   , "Strd"

  def empty?
    [unstructured_remittance_information, structured_remittance_information].compact == []
  end
end