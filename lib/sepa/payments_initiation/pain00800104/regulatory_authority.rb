class Sepa::PaymentsInitiation::Pain00800104::RegulatoryAuthority < Sepa::Base
  definition "Entity requiring the regulatory reporting information."
  attribute :name, "Nm"
  attribute :country, "Ctry"
end
