# -*- coding: utf-8 -*-

require 'iso3166'
require 'sepa/payments_initiation/pain00800104/customer_direct_debit_initiation'

class Sepa::DirectDebitOrder
  def self.new_order props
    o = Order.new
    o.message_id = props[:message_identification]
    p = o.initiating_party = Party.new
    p.name           = props[:name]
    p.address_line_1 = props[:address_1]
    p.address_line_2 = props[:address_2]
    p.postcode       = props[:postcode]
    p.town           = props[:town]
    p.country        = props[:country]
    p.contact_name   = props[:contact]
    p.contact_phone  = props[:phone]
    p.contact_email  = props[:email]
  end

  module Helper
    def blank? item
      item == nil || blank_string?(item)
    end

    def blank_string? item
      item.is_a?(String) && item.strip.length == 0
    end

    def county_code name
      return "" if blank?(name)
      name = name.upcase
      return name if name.match(/^[A-Z]{2}$/)
      country = ISO3166::Country.find_country_by_name(name)
      country ? country.alpha2 : ""
    end
  end

  class Order
    attr_accessor :message_id, :initiating_party, :creditor_payments

    def initialize message_id, initiating_party, creditor_payments
      @message_id, @initiating_party, @creditor_payments = message_id, initiating_party, creditor_payments
    end

    def new_payment
      self.creditor_payments ||= []
      cp = CreditorPayment.new
      cp.id              = props[:payment_identification]
      cp.collection_date = props[:collection_date]
      p   =  cp.creditor = Party.new
      p.name             = props[:name]
      p.address_line_1   = props[:address_1]
      p.address_line_2   = props[:address_2]
      p.postcode         = props[:postcode]
      p.town             = props[:town]
      p.country          = props[:country]
      p.contact_name     = props[:contact]
      p.contact_phone    = props[:phone]
      p.contact_email    = props[:email]

      a       = cp.creditor_account = BankAccount.new
      a.iban  = props[:iban]
      a.swift = props[:bic]

      sepa_id = if props[:sepa_identifier][:private]
                  PrivateSepaIdentifier.new(props[:sepa_identifier][:private])
                else
                  OrganisationSepaIdentifier.new(props[:sepa_identifier][:organisation])
                end

      cp.sepa_identification = sepa_id

      self.creditor_payments << cp
      cp
    end

    def to_properties opts
      hsh = {
        "group_header.message_identification"  => message_id,
        "group_header.creation_date_time"      => Time.now,
        "group_header.number_of_transactions"  => creditor_payments.inject(0) { |sum, cp| sum + cp.number_of_transactions },
        "group_header.control_sum"             => creditor_payments.inject(0) { |sum, cp| sum + cp.control_sum            },
      }

      hsh = hsh.merge initiating_party.to_properties("group_header.initiating_party", opts.merge({:context => :initiating_party}))

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
      cc = county_code country
      hsh = { "#{prefix}.name" => name }
      if (opts[:context] != :initiating_party) || (opts[:pain_008_001_version] != "02")
        hsh["#{prefix}.postal_address.address_line[0]"] = address_line_1 unless blank? address_line_1

        if opts[:pain_008_001_version] == "02"
          candidate_adr_line_2 = "#{postcode} #{town}".strip
          address_line_2 = candidate_adr_line_2 unless blank? candidate_adr_line_2
          hsh["#{prefix}.postal_address.address_line[1]"] = address_line_2 unless blank? address_line_2
        else
          hsh["#{prefix}.postal_address.post_code"]       = postcode       unless blank? postcode
          hsh["#{prefix}.postal_address.town_name"]       = town           unless blank? town
        end
        hsh["#{prefix}.postal_address.country"]         = cc             unless blank? cc

        unless opts[:pain_008_001_version] == "02"
          hsh["#{prefix}.contact_details.name"]           = contact_name   unless blank? contact_name
          hsh["#{prefix}.contact_details.phone_number"]   = contact_phone  unless blank? contact_phone
          hsh["#{prefix}.contact_details.email_address"]  = contact_email  unless blank? contact_email
        end
      end
      hsh
    end
  end

  class PrivateSepaIdentifier < Struct.new(:sepa_identifier)
    def to_properties prefix, opts
      { "#{prefix}.identification.private_identification.other.identification" => sepa_identifier,
        "#{prefix}.identification.private_identification.other.scheme_name.proprietary" => "SEPA"  }
    end
  end

  class OrganisationSepaIdentifier < Struct.new(:sepa_identifier)
    def to_properties prefix, opts
      { "#{prefix}.identification.organisation_identification.other.identification" => sepa_identifier,
        "#{prefix}.identification.organisation_identification.other.scheme_name.proprietary" => "SEPA"  }
    end
  end

  class CreditorPayment
    attr_accessor :creditor, :creditor_account, :id, :collection_date, :sepa_identification
    attr_accessor :direct_debits, :sequence_type

    def initialize creditor, creditor_account, id, collection_date, sepa_identification, direct_debits
      @creditor, @creditor_account = creditor, creditor_account
      @id, @collection_date, @sepa_identification = id, collection_date, sepa_identification
      @direct_debits = direct_debits
    end

    # This is only called for V02, in which case SequenceType is mandatory.
    # Necessary because each PaymentInformation container contains a single SequenceType element (inside PaymentTypeInformation)
    # whereas in V04, there is one SequenceType element per DirectDebitTransactionInformation
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
        ncp = CreditorPayment.new(creditor, creditor_account, "#{id}-#{seq_type}", collection_date, sepa_identification, dds)
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
        "#{prefix}.control_sum"                                    => control_sum,
        "#{prefix}.charge_bearer"                                  => "SLEV"
      }

      if opts[:pain_008_001_version] == "02"
        hsh["#{prefix}.payment_type_information.sequence_type"] = sequence_type
      end

      hsh = hsh.merge creditor.to_properties("#{prefix}.creditor", opts.merge({ :context => :creditor }))
      hsh = hsh.merge creditor_account.to_properties("#{prefix}.creditor", opts)
      hsh = hsh.merge sepa_identification.to_properties("#{prefix}.creditor_scheme_identification", opts)

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
      bic_tag = ( opts[:pain_008_001_version] == "04" ? "bic_fi" : "bic" )

      { "#{prefix}_account.identification.iban"                           => iban.gsub(/\s/, ''),
        "#{prefix}_agent.financial_institution_identification.#{bic_tag}" => swift }
    end
  end

  class MandateInformation < Struct.new(:identification, :signature_date, :sequence_type); end

  class DirectDebit
    attr_accessor :debtor, :debtor_account, :end_to_end_id, :amount, :currency, :mandate_info

    def initialize debtor, debtor_account, end_to_end_id, amount, currency, mandate_info
      @debtor, @debtor_account, @end_to_end_id, @amount, @currency, @mandate_info = debtor, debtor_account, end_to_end_id, amount, currency, mandate_info
    end

    def sequence_type
      mandate_info.sequence_type
    end

    def to_properties prefix, opts
      hsh = {
        "#{prefix}.payment_identification.end_to_end_identification"         => end_to_end_id,
        "#{prefix}.instructed_amount"                                        => ("%.2f" % amount),
        "#{prefix}.instructed_amount_currency"                               => "EUR",
        "#{prefix}.direct_debit_transaction.mandate_related_information.mandate_identification" => mandate_info.identification,
        "#{prefix}.direct_debit_transaction.mandate_related_information.date_of_signature"      => mandate_info.signature_date
      }
      hsh = hsh.merge debtor.to_properties("#{prefix}.debtor", opts)
      hsh = hsh.merge debtor_account.to_properties("#{prefix}.debtor", opts)

      if opts[:pain_008_001_version] == "04"
        hsh["#{prefix}.payment_type_information.sequence_type"] = mandate_info.sequence_type
      end

      hsh
    end
  end

end
