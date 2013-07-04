class Sepa::PaymentsInitiation::ContactDetails < Sepa::Base
  attribute :name_prefix  , "NmPrfx"
  attribute :name         , "Nm"
  attribute :phone_number , "PhneNb"
  attribute :mobile_number, "MobNb"
  attribute :fax_number   , "FaxNb"
  attribute :email_address, "EmailAdr"
  attribute :other        , "Othr"
end
