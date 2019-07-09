class Sepa::PaymentsInitiation::PostalAddress < Sepa::Base
  definition "Information that locates and identifies a specific address, as defined by postal services."
  attribute :address_type         , "AdrTyp"
  attribute :department           , "Dept"
  attribute :sub_department       , "SubDept"
  attribute :street_name          , "StrtNm"
  attribute :building_number      , "BldgNb"
  attribute :post_code            , "PstCd"
  attribute :town_name            , "TwnNm"
  attribute :country_sub_division , "CtySubDvsn"
  attribute :country              , "Ctry"
  attribute :address_line         , "AdrLine"    , :[], Sepa::Max70Text
end
