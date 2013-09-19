# -*- coding: utf-8 -*-

require "spec_helper"

describe Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation do

  it "should produce xml corresponding to the given inputs" do
    props = {
      "group_header.message_identification"                             => "MSG0001",
      "group_header.creation_date_time"                                 => "1992-02-28T18:30:00",
      "group_header.number_of_transactions"                             => "2",
      "group_header.initiating_party.name"                              => "SOFTIFY SARL",
      "group_header.initiating_party.postal_address.address_line[0]"    => "289, Livva de Getamire",
      "group_header.initiating_party.postal_address.post_code"          => "75021",
      "group_header.initiating_party.postal_address.town_name"          => "Paris",
      "group_header.initiating_party.postal_address.country"            => "FR",
      "group_header.initiating_party.contact_details.name"              => "M. Le Gérant",
      "group_header.initiating_party.contact_details.phone_number"      => "+33 111 111 111",
      "group_header.initiating_party.contact_details.email_address"     =>  "gerant@softify.bigbang",
      "payment_information[0].payment_information_identification"       => "MONECOLE_PAYMENTS_20130703",
      "payment_information[0].payment_method"                           => "DD",
      "payment_information[0].requested_collection_date"                => "2013-07-10",
      "payment_information[0].creditor.name"                            => "Mon École",
      "payment_information[0].creditor.postal_address.address_line[0]"  => "3, Livva de Getamire",
      "payment_information[0].creditor.postal_address.post_code"        => "75022",
      "payment_information[0].creditor.postal_address.town_name"        => "Paris",
      "payment_information[0].creditor.postal_address.country"          => "FR",
      "payment_information[0].creditor.contact_details.name"            => "M. le Directeur",
      "payment_information[0].creditor.contact_details.phone_number"    => "+33 999 999 999",
      "payment_information[0].creditor.contact_details.email_address"   => "directeur@monecole.softify.com",
      "payment_information[0].creditor_account.identification.iban"     => "FRGOOGOOYADDA9999999",
      "payment_information[0].creditor_agent.financial_institution_identification.bic_fi"                                       => "FRGGYELLOW99",
      "payment_information[0].direct_debit_transaction_information[0].payment_identification.end_to_end_identification"         => "MONECOLE REG F13789 PVT 3",
      "payment_information[0].direct_debit_transaction_information[0].instructed_amount"                                        => "1231.31",
      "payment_information[0].direct_debit_transaction_information[0].instructed_amount_currency"                               => "EUR",
      "payment_information[0].direct_debit_transaction_information[0].debtor_agent.financial_institution_identification.bic_fi" => "FRZZPPKOOKOO",
      "payment_information[0].direct_debit_transaction_information[0].debtor.name"                                              => "DALTON/CONANMR",
      "payment_information[0].direct_debit_transaction_information[0].debtor.postal_address.address_line[0]"                    => "64, Livva de Getamire",
      "payment_information[0].direct_debit_transaction_information[0].debtor.postal_address.post_code"                          => "30005",
      "payment_information[0].direct_debit_transaction_information[0].debtor.postal_address.town_name"                          => "RENNES",
      "payment_information[0].direct_debit_transaction_information[0].debtor.postal_address.country"                            => "FR",
      "payment_information[0].direct_debit_transaction_information[0].debtor.contact_details.name"                              => "Conan DALTON",
      "payment_information[0].direct_debit_transaction_information[0].debtor.contact_details.phone_number"                      => "01234567890",
      "payment_information[0].direct_debit_transaction_information[0].debtor.contact_details.email_address"                     => "conan@dalton.sepa.i.hope.this.works",
      "payment_information[0].direct_debit_transaction_information[0].debtor_account.identification.iban"                       => "FRZIZIPAPARAZZI345789",
      "payment_information[0].direct_debit_transaction_information[1].payment_identification.end_to_end_identification"         => "MONECOLE REG F13790 PVT 3",
      "payment_information[0].direct_debit_transaction_information[1].payment_type_information.sequence_type"                   => "FRST",
      "payment_information[0].direct_debit_transaction_information[1].instructed_amount"                                        => "1732.32",
      "payment_information[0].direct_debit_transaction_information[1].instructed_amount_currency"                               => "EUR",
      "payment_information[0].direct_debit_transaction_information[1].debtor_agent.financial_institution_identification.bic_fi" => "FRQQWIGGA",
      "payment_information[0].direct_debit_transaction_information[1].debtor.name"                                              => "ADAMS/SAMUELMR",
      "payment_information[0].direct_debit_transaction_information[1].debtor.postal_address.address_line[0]"                    => "256, Livva de Getamire",
      "payment_information[0].direct_debit_transaction_information[1].debtor.postal_address.post_code"                          => "75048",
      "payment_information[0].direct_debit_transaction_information[1].debtor.postal_address.town_name"                          => "PARIS",
      "payment_information[0].direct_debit_transaction_information[1].debtor.postal_address.country"                            => "FR",
      "payment_information[0].direct_debit_transaction_information[1].debtor_account.identification.iban"                       => "FRQUIQUIWIGWAM947551",
      "payment_information[0].direct_debit_transaction_information[1].debtor.contact_details.name"                              => "Samuel ADAMS",
      "payment_information[0].direct_debit_transaction_information[1].debtor.contact_details.phone_number"                      => "09876543210",
      "payment_information[0].direct_debit_transaction_information[1].debtor.contact_details.email_address"                     => "samuel@adams.sepa.i.hope.this.works"
    }

    xml = Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation.new(props).generate_xml
    expected = File.read(File.expand_path("../../../expected_customer_direct_debit_initiation.xml", __FILE__))
    xml.should == expected
  end
end

