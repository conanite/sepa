# -*- coding: utf-8 -*-

require 'sepa/payments_initiation/pain00800104/customer_direct_debit_initiation'

class Sepa::DirectDebitOrder

  module Helper
    def blank? item
      item == nil || blank_string?(item)
    end

    def blank_string? item
      item.is_a?(String) && item.strip.length == 0
    end
  end

  class Order
    attr_accessor :message_id, :initiating_party, :creditor_payments

    def initialize message_id, initiating_party, creditor_payments
      @message_id, @initiating_party, @creditor_payments = message_id, initiating_party, creditor_payments
    end

    def to_properties opts
      hsh = {
        "group_header.message_identification"  => message_id,
        "group_header.creation_date_time"      => Time.now,
        "group_header.number_of_transactions"  => creditor_payments.inject(0) { |sum, cp| sum + cp.number_of_transactions },
        "group_header.control_sum"             => creditor_payments.inject(0) { |sum, cp| sum + cp.control_sum            },
      }

      hsh = hsh.merge initiating_party.to_properties("group_header.initiating_party", opts)

      cps = []
      if opts[:pain_008_001_version] == "02"
        creditor_payments.each do |creditor_payment|
          creditor_payment.collect_by_sequence_type { |cp| cps << cp }
        end
      else
        cps = creditor_payments
      end

      cps.each_with_index { |cp, i|
        hsh = hsh.merge(cp.to_properties("payment_information[#{i}]", opts))
      }

      hsh
    end

    def to_xml opts={ }
      Sepa::PaymentsInitiation::Pain00800104::CustomerDirectDebitInitiation.new(to_properties opts).generate_xml(opts)
    end
  end

  class Party
    include Helper
    attr_accessor :name, :address_line_1, :address_line_2, :postcode, :town, :country, :contact_name, :contact_phone, :contact_email

    def initialize name, address_line_1, address_line_2, postcode, town, country, contact_name, contact_phone, contact_email
      @name, @address_line_1, @address_line_2, @postcode, @town, @country = name, address_line_1, address_line_2, postcode, town, country
      @contact_name, @contact_phone, @contact_email = contact_name, contact_phone, contact_email
    end

    def to_properties prefix, opts
      hsh = { "#{prefix}.name" => name }
      hsh["#{prefix}.postal_address.address_line[0]"] = address_line_1 unless blank? address_line_1
      hsh["#{prefix}.postal_address.address_line[1]"] = address_line_2 unless blank? address_line_2
      hsh["#{prefix}.postal_address.post_code"]       = postcode       unless blank? postcode
      hsh["#{prefix}.postal_address.town_name"]       = town           unless blank? town
      hsh["#{prefix}.postal_address.country"]         = country        unless blank? country
      hsh["#{prefix}.contact_details.name"]           = contact_name   unless blank? contact_name
      hsh["#{prefix}.contact_details.phone_number"]   = contact_phone  unless blank? contact_phone
      hsh["#{prefix}.contact_details.email_address"]  = contact_email  unless blank? contact_email
      hsh
    end
  end

  class CreditorPayment
    attr_accessor :creditor, :creditor_account, :id, :collection_date
    attr_accessor :direct_debits, :sequence_type

    def initialize creditor, creditor_account, id, collection_date, direct_debits
      @creditor, @creditor_account = creditor, creditor_account
      @id, @collection_date = id, collection_date
      @direct_debits = direct_debits
    end

    # this is only called for V02, in which case SequenceType is mandatory
    def collect_by_sequence_type
      seq_types = {
        "FRST" => [],
        "RCUR" => [],
        "FNAL" => [],
        "OOFF" => []
      }

      direct_debits.each do |dd|
        seq_types[dd.sequence_type] << dd
      end

      seq_types.each do |seq_type, dds|
        next if dds.empty?
        ncp = CreditorPayment.new(creditor, creditor_account, "#{id}_#{seq_type}", collection_date, dds)
        ncp.sequence_type = seq_type
        yield ncp
      end
    end

    def number_of_transactions
      direct_debits.length
    end

    def control_sum
      direct_debits.inject(0) { |sum, dd| sum + dd.amount }
    end

    def to_properties prefix, opts
      hsh = {
        "#{prefix}.payment_information_identification"             => id,
        "#{prefix}.payment_type_information.service_level.code"    => "SEPA",
        "#{prefix}.payment_type_information.local_instrument.code" => "CORE",
        "#{prefix}.payment_method"                                 => "DD",
        "#{prefix}.requested_collection_date"                      => collection_date,
        "#{prefix}.number_of_transactions"                         => number_of_transactions,
        "#{prefix}.control_sum"                                    => control_sum
      }

      if opts[:pain_008_001_version] == "02"
        hsh["#{prefix}.payment_type_information.sequence_type"] = sequence_type
      end

      hsh = hsh.merge creditor.to_properties("#{prefix}.creditor", opts)
      hsh = hsh.merge creditor_account.to_properties("#{prefix}.creditor", opts)

      direct_debits.each_with_index { |dd, j|
        hsh = hsh.merge(dd.to_properties("#{prefix}.direct_debit_transaction_information[#{j}]", opts))
      }

      hsh
    end
  end

  class BankAccount
    attr_accessor :iban, :swift

    def initialize iban, swift
      @iban, @swift = iban, swift
    end

    def to_properties prefix, opts
      { "#{prefix}_account.identification.iban"                       => iban,
        "#{prefix}_agent.financial_institution_identification.bic_fi" => swift }
    end
  end

  class DirectDebit
    attr_accessor :debtor, :debtor_account, :end_to_end_id, :amount, :currency, :sequence_type, :mandate_identification

    def initialize debtor, debtor_account, end_to_end_id, amount, currency, sequence_type, mandate_identification
      @debtor, @debtor_account, @end_to_end_id, @amount, @currency, @sequence_type, @mandate_identification = debtor, debtor_account, end_to_end_id, amount, currency, sequence_type, mandate_identification
    end

    def to_properties prefix, opts
      hsh = {
        "#{prefix}.payment_identification.end_to_end_identification"         => end_to_end_id,
        "#{prefix}.instructed_amount"                                        => ("%.2f" % amount),
        "#{prefix}.instructed_amount_currency"                               => "EUR",
        "#{prefix}.direct_debit_transaction.mandate_related_information.mandate_identification" => mandate_identification
      }
      hsh = hsh.merge debtor.to_properties("#{prefix}.debtor", opts)
      hsh = hsh.merge debtor_account.to_properties("#{prefix}.debtor", opts)

      if opts[:pain_008_001_version] == "04"
        hsh["#{prefix}.payment_type_information.sequence_type"] = sequence_type
      end

      hsh
    end
  end

end
