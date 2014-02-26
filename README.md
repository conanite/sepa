# Sepa

An implementation of pain.008.001 CustomerDirectDebitInitiation - versions 02 and 04. WARNING:
NO WARRANTY, USE AT YOUR OWN RISK AND PERIL. By using this software, you warrant and represent
and declare that having studied and examined and tested the source, you are satisfied, sure, and
certain that the version you use does exactly what you want it to do. This

MORE WARNING: This is alpha-quality software. The API is not yet stable. New versions will break
compatibility in unpredictable ways. Use at your own risk and peril.

ANOTHER WARNING: While I aim for ISO-20022 compatibility in all its glorious detail, this gem
implements only a subset of ISO-20022, and possibly does so incorrectly. On top of that, your
bank's interpretation of ISO-20022 may differ from mine, may require some fields that are
optional in the ISO specification, and may ignore some other fields that are mandatory in the
specification.

I wanted to make it as easy as possible to define message types and components so this library
will be easy to grow to implement the entire standard.

Implementations of other messages are welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'sepa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sepa

## Usage

The simplest way to generate a pain.008.001 xml message is to use the DirectDebitOrder module
which exposes only the bare essentials. Which is still a lot, but hey, this is a banking
standard, what do you expect.

Please see the spec for an up-to-date example of api usage. In the pseudo-ruby example below,
you need to supply a list of direct-debit objects, a creditor object, an initiator object, and
a message-id.

    def create_sepa_direct_debit_order direct_debits, creditor, initiator, message_id
      dd_list = []

      # for each direct debit you want to order ...

      for(each dd in direct_debits) do | ... |
        bank_account = Sepa::DirectDebitOrder::BankAccount.new dd.iban, dd.bic
        debtor = Sepa::DirectDebitOrder::Party.new dd.name, dd.addr, nil, dd.postcode, dd.town, dd.country, dd.contact, dd.phone, dd.email
        mandate = Sepa::DirectDebitOrder::MandateInformation.new dd.mandate_id, dd.sig_date, dd.sequence_type
        dd_list << Sepa::DirectDebitOrder::DirectDebit.new debtor, bank_account, dd.end_to_end_id, dd.amount, "EUR", mandate
      end

      creditor = Sepa::DirectDebitOrder::Party.new creditor.name, creditor.address, nil, creditor.postcode, creditor.town, creditor.country, creditor.contact, creditor.phone, creditor.email

      creditor_account = Sepa::DirectDebitOrder::BankAccount.new creditor.iban, creditor.bic

      sepa_identifier = Sepa::DirectDebitOrder::PrivateSepaIdentifier.new creditor.sepa_identifier

      payment = Sepa::DirectDebitOrder::CreditorPayment.new creditor, creditor_account, payment_identifier, collection_date, sepa_identifier, dd_list

      initiator = Sepa::DirectDebitOrder::Party.new initiator.identifier, initiator.address, nil, initiator.postcode, initiator.town, initiator.country, initiator.contact, initiator.phone, initiator.email

      order = Sepa::DirectDebitOrder::Order.new message_id, initiator, [payment]

      order.to_xml pain_008_001_version: "04"
    end

The last line returns a string that you will then need to send to your bank one way or another. For example, you might use an EBICS client. Or your bank might provide
software to send the file. Or perhaps you can upload it via their website.

If your bank expects a particular time format, do this (for example)

    Sepa::Base.time_format = "%Y-%m-%dT%H:%M:%SZ" # btw, this is the default value

This sets a class variable, which is effectively a global, non-thread-safe variable, so this might change in the future, in case we need to support usage where multiple clients need to generate XML with different time format requirements.

## History

0.0.17
* Use 'NOTPROVIDED' instead of BIC (requirement from ABN-AMRO Netherlands) (thanks @joostkuif)
* Support various ruby kinds of number (thanks @TheConstructor)
* Configurable time format string for time elements (so far, only CstmrDrctDbtInitn/GrpHdr/CreDtTm)
0.0.16 BigDecimal to avoid floating-point rounding errors (w/thanks to @joostkuif), support RemittanceInformation (w/thanks to @TheConstructor)
0.0.15 Ruby 1.8.7 compatibility

## Contributing

Other message types are totally welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

Author: [Conan Dalton](http://www.conandalton.net), aka [conanite](https://github.com/conanite)
With thanks to [corny](https://github.com/corny), [TheConstructor](https://github.com/TheConstructor), [joostkuif](https://github.com/joostkuif), [digineo](https://github.com/digineo)
