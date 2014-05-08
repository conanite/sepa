class Sepa::PaymentsInitiation::ContactDetails < Sepa::Base
  attribute :name_prefix  , "NmPrfx"
  attribute :name         , "Nm",      Sepa::Max70Text
  attribute :phone_number , "PhneNb"
  attribute :mobile_number, "MobNb"
  attribute :fax_number   , "FaxNb"
  attribute :email_address, "EmailAdr"
  attribute :other        , "Othr"

  def empty?
    [name_prefix, name, phone_number, mobile_number, fax_number, email_address, other].compact == []
  end
end
