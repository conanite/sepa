# -*- coding: utf-8 -*-

require "spec_helper"
require "time"
require 'bigdecimal'
require 'rational'

describe Sepa::DirectDebitOrder do

  AMOUNTS = {
      :Float => [1231.31, 1133.33, 1732.32, 1034.34, 1935.35, 1236.36],
      :BigDecimal => [BigDecimal.new('1231.31'), BigDecimal.new('1133.33'), BigDecimal.new('1732.32'), BigDecimal.new('1034.34'), BigDecimal.new('1935.35'), BigDecimal.new('1236.36')],
      :Rational => [Rational.reduce(123131, 100), Rational.reduce(113333, 100), Rational.reduce(173232, 100), Rational.reduce(103434, 100), Rational.reduce(193535, 100), Rational.reduce(123636, 100)],
  }

  def order sepa_identifier_class, numeric_class = :Float, remittance_information = false
    amounts = AMOUNTS[numeric_class]

    bank_account0 = Sepa::DirectDebitOrder::BankAccount.new "FRZIZIPAPARAZZI345789", "FRZZPPKOOKOO"
    debtor0 = Sepa::DirectDebitOrder::Party.new "DALTON/CONANMR", "64, Livva de Getamire", nil, "30005", "RENNES", "France", "Conan DALTON", "01234567890", "conan@dalton.sepa.i.hope.this.works"
    mandate0 = Sepa::DirectDebitOrder::MandateInformation.new("mandate-id-0", Date.parse("2010-11-18"), "RCUR")
    dd00 = Sepa::DirectDebitOrder::DirectDebit.new debtor0, bank_account0, "MONECOLE REG F13789 PVT 3", amounts[0], "EUR", mandate0, remittance_information ? "Transaction 3" : nil
    dd01 = Sepa::DirectDebitOrder::DirectDebit.new debtor0, bank_account0, "MONECOLE REG F13791 PVT 3", amounts[1], "EUR", mandate0, remittance_information ? "We take your money" : nil

    bank_account1 = Sepa::DirectDebitOrder::BankAccount.new "FRQUIQUIWIGWAM947551", "FRQQWIGGA"
    debtor1 = Sepa::DirectDebitOrder::Party.new "ADAMS/SAMUELMR", "256, Livva de Getamire", nil, "75048", "BERLIN", "Germany", "Samuel ADAMS", "09876543210", "samuel@adams.sepa.i.hope.this.works"
    mandate1 = Sepa::DirectDebitOrder::MandateInformation.new("mandate-id-1", Date.parse("2012-01-19"), "FRST")
    dd10 = Sepa::DirectDebitOrder::DirectDebit.new debtor1, bank_account1, "MONECOLE REG F13790 PVT 3", amounts[2], "EUR", mandate1, remittance_information ? "An important transaction" : nil
    dd11 = Sepa::DirectDebitOrder::DirectDebit.new debtor1, bank_account1, "MONECOLE REG F13792 PVT 3", amounts[3], "EUR", mandate1, remittance_information ? "Thank you, for the money" : nil

    bank_account2 = Sepa::DirectDebitOrder::BankAccount.new "  FR QU IQ UI WI GW\tAM   947 551  ", "FRQQWIGGA"
    debtor2 = Sepa::DirectDebitOrder::Party.new "Mr. James Joyce", "512, Livva de Meet Agir", nil, "75099", "LONDON", "Angleterre", "Johann S. BACH", "09876543210", "js@bach.sepa.i.hope.this.works"
    mandate2 = Sepa::DirectDebitOrder::MandateInformation.new("mandate-id-2", Date.parse("2013-06-08"), "RCUR")
    dd20 = Sepa::DirectDebitOrder::DirectDebit.new debtor2, bank_account2, "MONECOLE REG F13793 PVT 3", amounts[4], "EUR", mandate2, remittance_information ? "Another one" : nil
    dd21 = Sepa::DirectDebitOrder::DirectDebit.new debtor2, bank_account2, "MONECOLE REG F13794 PVT 3", amounts[5], "EUR", mandate2, remittance_information ? "Final transaction" : nil

    sepa_now = Time.local(1992, 2, 28, 18, 30, 0, 0, 0)
    Time.stub(:now).and_return sepa_now

    creditor = Sepa::DirectDebitOrder::Party.new "Mon École", "3, Livva de Getamire", nil, "75022", "Paris", "Frankreich", "M. le Directeur", "+33 999 999 999", "directeur@monecole.softify.com"
    creditor_account = Sepa::DirectDebitOrder::BankAccount.new "FRGOO GOOY ADDA 9999 999", "FRGGYELLOW99"
    sepa_identifier = sepa_identifier_class.new "FR123ZZZ010203"
    payment = Sepa::DirectDebitOrder::CreditorPayment.new creditor, creditor_account, "MONECOLE_PAYMENTS_20130703", Date.parse("2013-07-10"), sepa_identifier, [dd00, dd01, dd10, dd11, dd20, dd21]

    initiator = Sepa::DirectDebitOrder::Party.new "SOFTIFY SARL", "289, Livva de Getamire", nil, "75021", "Paris", "FR", "M. Le Gérant", "+33 111 111 111", "gerant@softify.bigbang"

    Sepa::DirectDebitOrder::Order.new "MSG0001", initiator, [payment]
  end

  it "should produce v02 xml corresponding to the given inputs" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier
    xml = o.to_xml :pain_008_001_version => "02"
    xml = check_doc_header_02 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v02.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v02 xml corresponding to the given inputs and BigDecimal amounts" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier, :BigDecimal
    xml = o.to_xml :pain_008_001_version => "02"
    xml = check_doc_header_02 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v02.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v02 xml corresponding to the given inputs and Rational amounts" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier, :Rational
    xml = o.to_xml :pain_008_001_version => "02"
    xml = check_doc_header_02 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v02.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v02 xml corresponding to the given inputs with unstructured remittance information" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier, :Float, true
    xml = o.to_xml :pain_008_001_version => "02"
    xml = check_doc_header_02 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v02_with_remittance_information.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v04 xml corresponding to the given inputs" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier
    xml = o.to_xml :pain_008_001_version => "04"
    xml = check_doc_header_04 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v04.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v04 xml corresponding to the given inputs and BigDecimal amounts" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier, :BigDecimal
    xml = o.to_xml :pain_008_001_version => "04"
    xml = check_doc_header_04 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v04.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v04 xml corresponding to the given inputs and Rational amounts" do
    o = order Sepa::DirectDebitOrder::PrivateSepaIdentifier, :Rational
    xml = o.to_xml :pain_008_001_version => "04"
    xml = check_doc_header_04 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v04.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should produce v04 xml corresponding to the given inputs with an organisation identifier for the creditor" do
    o = order Sepa::DirectDebitOrder::OrganisationSepaIdentifier
    xml = o.to_xml :pain_008_001_version => "04"
    xml = check_doc_header_04 xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v04_with_org_id.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8) if expected.respond_to? :force_encoding
    xml.should == expected
  end

  it "should not produce empty address elements" do
    debtor = Sepa::DirectDebitOrder::Party.new "M Conan Dalton", "", nil, "", "", nil, nil, "", ""
    props = debtor.to_properties "x", { }
    props["x.name"].should == "M Conan Dalton"
    props.keys.length.should == 1
  end
end
