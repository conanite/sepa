# -*- coding: utf-8 -*-

class Sepa::DirectDebitOrder

  class Order
    attr_accessor :message_id, :initiating_party, :creditor_payments

    def initialize message_id, initiating_party, creditor_payments
      @message_id, @initiating_party, @creditor_payments = message_id, initiating_party, creditor_payments
    end

    def to_properties
      hsh = {
        "group_header.message_identification"                             => message_id,
        "group_header.creation_date_time"                                 => Time.now,
        "group_header.number_of_transactions"                             => creditor_payments.inject(0) { |sum, cp| sum + cp.number_of_transactions },
      }

      hsh = hsh.merge initiating_party.to_properties("group_header.initiating_party")

      creditor_payments.each_with_index { |cp, i|
        hsh = hsh.merge(cp.to_properties("payment_information[#{i}]"))
      }

      hsh
    end

    def to_xml
      Sepa.to_xml(Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation.new(to_properties))
    end
  end

  class Party
    attr_accessor :name, :address_line_1, :address_line_2, :postcode, :town, :country, :contact_name, :contact_phone, :contact_email

    def initialize name, address_line_1, address_line_2, postcode, town, country, contact_name, contact_phone, contact_email
      @name, @address_line_1, @address_line_2, @postcode, @town, @country = name, address_line_1, address_line_2, postcode, town, country
      @contact_name, @contact_phone, @contact_email = contact_name, contact_phone, contact_email
    end

    def to_properties prefix
      hsh = {
        "#{prefix}.name"                                              => name,
        "#{prefix}.postal_address.address_line[0]"                    => address_line_1,
        "#{prefix}.postal_address.post_code"                          => postcode,
        "#{prefix}.postal_address.town_name"                          => town,
        "#{prefix}.postal_address.country"                            => country,
        "#{prefix}.contact_details.name"                              => contact_name,
        "#{prefix}.contact_details.phone_number"                      => contact_phone,
        "#{prefix}.contact_details.email_address"                     => contact_email,
      }

      hsh["#{prefix}.postal_address.address_line[1]"] = address_line_2 if address_line_2

      hsh
    end
  end

  class CreditorPayment
    attr_accessor :creditor, :creditor_account, :id, :collection_date
    attr_accessor :direct_debits

    def initialize creditor, creditor_account, id, collection_date, direct_debits
      @creditor, @creditor_account = creditor, creditor_account
      @id, @collection_date = id, collection_date
      @direct_debits = direct_debits
    end

    def number_of_transactions
      direct_debits.length
    end

    def to_properties prefix
      hsh = {
        "#{prefix}.payment_information_identification"                         => id,
        "#{prefix}.payment_method"                                             => "DD",
        "#{prefix}.requested_collection_date"                                  => collection_date
      }

      hsh = hsh.merge creditor.to_properties("#{prefix}.creditor")
      hsh = hsh.merge creditor_account.to_properties("#{prefix}.creditor")

      direct_debits.each_with_index { |dd, j|
        hsh = hsh.merge(dd.to_properties("#{prefix}.direct_debit_transaction_information[#{j}]"))
      }

      hsh
    end
  end

  class BankAccount
    attr_accessor :iban, :swift

    def initialize iban, swift
      @iban, @swift = iban, swift
    end

    def to_properties prefix
      { "#{prefix}_account.identification.iban"                       => iban,
        "#{prefix}_agent.financial_institution_identification.bic_fi" => swift }
    end
  end

  class DirectDebit
    attr_accessor :debtor, :debtor_account, :end_to_end_id, :amount, :currency

    def initialize debtor, debtor_account, end_to_end_id, amount, currency
      @debtor, @debtor_account, @end_to_end_id, @amount, @currency = debtor, debtor_account, end_to_end_id, amount, currency
    end

    def to_properties prefix
      hsh = {
        "#{prefix}.payment_identification.end_to_end_identification"         => end_to_end_id,
        "#{prefix}.instructed_amount"                                        => ("%.2f" % amount),
        "#{prefix}.instructed_amount_currency"                               => "EUR",
      }
      hsh = hsh.merge debtor.to_properties("#{prefix}.debtor")
      hsh = hsh.merge debtor_account.to_properties("#{prefix}.debtor")
      hsh
    end
  end

end

