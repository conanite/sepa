# -*- coding: utf-8 -*-

require "spec_helper"
require "time"

describe Sepa::DirectDebitOrder do

  it "should produce xml corresponding to the given inputs" do
    bank_account0 = Sepa::DirectDebitOrder::BankAccount.new "FRZIZIPAPARAZZI345789", "FRZZPPKOOKOO"
    debtor0 = Sepa::DirectDebitOrder::Party.new "DALTON/CONANMR", "64, Livva de Getamire", nil, "30005", "RENNES", "FR", "Conan DALTON", "01234567890", "conan@dalton.sepa.i.hope.this.works"
    dd0 = Sepa::DirectDebitOrder::DirectDebit.new debtor0, bank_account0, "MONECOLE REG F13789 PVT 3", 1231.31, "EUR", nil, "mandate-id-0"

    bank_account1 = Sepa::DirectDebitOrder::BankAccount.new "FRQUIQUIWIGWAM947551", "FRQQWIGGA"
    debtor1 = Sepa::DirectDebitOrder::Party.new "ADAMS/SAMUELMR", "256, Livva de Getamire", nil, "75048", "PARIS", "FR", "Samuel ADAMS", "09876543210", "samuel@adams.sepa.i.hope.this.works"
    dd1 = Sepa::DirectDebitOrder::DirectDebit.new debtor1, bank_account1, "MONECOLE REG F13790 PVT 3", 1732.32, "EUR", "FRST", "mandate-id-1"

    sepa_now = Time.strptime "1992-02-28T18:30:00", "%Y-%m-%dT%H:%M:%S"
    Time.stub(:now).and_return sepa_now

    creditor = Sepa::DirectDebitOrder::Party.new "Mon École", "3, Livva de Getamire", nil, "75022", "Paris", "FR", "M. le Directeur", "+33 999 999 999", "directeur@monecole.softify.com"
    creditor_account = Sepa::DirectDebitOrder::BankAccount.new "FRGOOGOOYADDA9999999", "FRGGYELLOW99"
    payment = Sepa::DirectDebitOrder::CreditorPayment.new creditor, creditor_account, "MONECOLE_PAYMENTS_20130703", Date.parse("2013-07-10"), [dd0, dd1]

    initiator = Sepa::DirectDebitOrder::Party.new "SOFTIFY SARL", "289, Livva de Getamire", nil, "75021", "Paris", "FR", "M. Le Gérant", "+33 111 111 111", "gerant@softify.bigbang"

    order = Sepa::DirectDebitOrder::Order.new "MSG0001", initiator, [payment]

    xml = order.to_xml
    expected = File.read(File.expand_path("../expected_customer_direct_debit_initiation.xml", __FILE__))
    xml.should == expected
  end
end

