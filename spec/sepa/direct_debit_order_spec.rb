# -*- coding: utf-8 -*-

require "spec_helper"
require "time"

describe Sepa::DirectDebitOrder do

  let(:order) {
    bank_account0 = Sepa::DirectDebitOrder::BankAccount.new "FRZIZIPAPARAZZI345789", "FRZZPPKOOKOO"
    debtor0 = Sepa::DirectDebitOrder::Party.new "DALTON/CONANMR", "64, Livva de Getamire", nil, "30005", "RENNES", "FR", "Conan DALTON", "01234567890", "conan@dalton.sepa.i.hope.this.works"
    dd00 = Sepa::DirectDebitOrder::DirectDebit.new debtor0, bank_account0, "MONECOLE REG F13789 PVT 3", 1231.31, "EUR", "RCUR", "mandate-id-0"
    dd01 = Sepa::DirectDebitOrder::DirectDebit.new debtor0, bank_account0, "MONECOLE REG F13791 PVT 3", 1133.33, "EUR", "RCUR", "mandate-id-0"

    bank_account1 = Sepa::DirectDebitOrder::BankAccount.new "FRQUIQUIWIGWAM947551", "FRQQWIGGA"
    debtor1 = Sepa::DirectDebitOrder::Party.new "ADAMS/SAMUELMR", "256, Livva de Getamire", nil, "75048", "PARIS", "FR", "Samuel ADAMS", "09876543210", "samuel@adams.sepa.i.hope.this.works"
    dd10 = Sepa::DirectDebitOrder::DirectDebit.new debtor1, bank_account1, "MONECOLE REG F13790 PVT 3", 1732.32, "EUR", "FRST", "mandate-id-1"
    dd11 = Sepa::DirectDebitOrder::DirectDebit.new debtor1, bank_account1, "MONECOLE REG F13792 PVT 3", 1034.34, "EUR", "FRST", "mandate-id-1"

    bank_account2 = Sepa::DirectDebitOrder::BankAccount.new "FRQUIQUIWIGWAM947551", "FRQQWIGGA"
    debtor2 = Sepa::DirectDebitOrder::Party.new "ADAMS/SAMUELMR", "512, Livva de Meet Agir", nil, "75099", "PARIS", "FR", "Johann S. BACH", "09876543210", "js@bach.sepa.i.hope.this.works"
    dd20 = Sepa::DirectDebitOrder::DirectDebit.new debtor2, bank_account2, "MONECOLE REG F13793 PVT 3", 1935.35, "EUR", "RCUR", "mandate-id-1"
    dd21 = Sepa::DirectDebitOrder::DirectDebit.new debtor2, bank_account2, "MONECOLE REG F13794 PVT 3", 1236.36, "EUR", "RCUR", "mandate-id-1"

    sepa_now = Time.strptime "1992-02-28T18:30:00", "%Y-%m-%dT%H:%M:%S"
    Time.stub(:now).and_return sepa_now

    creditor = Sepa::DirectDebitOrder::Party.new "Mon École", "3, Livva de Getamire", nil, "75022", "Paris", "FR", "M. le Directeur", "+33 999 999 999", "directeur@monecole.softify.com"
    creditor_account = Sepa::DirectDebitOrder::BankAccount.new "FRGOOGOOYADDA9999999", "FRGGYELLOW99"
    payment = Sepa::DirectDebitOrder::CreditorPayment.new creditor, creditor_account, "MONECOLE_PAYMENTS_20130703", Date.parse("2013-07-10"), [dd00, dd01, dd10, dd11, dd20, dd21]

    initiator = Sepa::DirectDebitOrder::Party.new "SOFTIFY SARL", "289, Livva de Getamire", nil, "75021", "Paris", "FR", "M. Le Gérant", "+33 111 111 111", "gerant@softify.bigbang"

    Sepa::DirectDebitOrder::Order.new "MSG0001", initiator, [payment]
  }

   it "should produce v02 xml corresponding to the given inputs" do
    xml = order.to_xml pain_008_001_version: "02"
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v02.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8)
    xml.should == expected
  end

  it "should produce v04 xml corresponding to the given inputs" do
    xml = order.to_xml pain_008_001_version: "04"
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation_v04.xml", __FILE__))
    expected.force_encoding(Encoding::UTF_8)
    xml.should == expected
  end

  it "should not produce empty address elements" do
    debtor = Sepa::DirectDebitOrder::Party.new "M Conan Dalton", "", nil, "", "", nil, nil, "", ""
    props = debtor.to_properties "x", { }
    props["x.name"].should == "M Conan Dalton"
    props.keys.length.should == 1
  end
end
