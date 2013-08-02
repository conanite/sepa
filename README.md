# Sepa

An implementation of pain.008.001.04 CustomerDirectDebitInitiation. WARNING: NO WARRANTY, USE AT YOUR OWN RISK AND PERIL.

I wanted to make it as easy as possible to define message types and components so this library will be easy to grow to implement the entire standard.

Implementations of other messages are welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'sepa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sepa

## Usage

The simplest way to generate a pain.008.001.04 xml message is to use the DirectDebitOrder module which exposes only the bare essentials. Which
is still a lot, but hey, this is a banking standard, what do you expect.

Here's an example, ripped off from the spec, of a direct debit order for payments to a single creditor. You need to provide a list of direct
debits, each with information about the amount, the bank account to debit, and the name and contact details of the debtor. You also need to
provide a "creditor" and "initiator" object, which also contain bank account and contact details. Finally, you need to supply a message identifier.

    def create_sepa_direct_debit_order direct_debits, creditor, initiator, message_id
      dd_list = []

      # for each direct debit you want to order ...

      for(each direct_debit to order) do | ... |
        bank_account = Sepa::DirectDebitOrder::BankAccount.new direct_debit.iban, direct_debit.bic
        debtor = Sepa::DirectDebitOrder::Party.new direct_debit.name, direct_debit.addr, nil, direct_debit.postcode, direct_debit.town, direct_debit.country, direct_debit.contact, direct_debit.phone, direct_debit.email
        dd_list << Sepa::DirectDebitOrder::DirectDebit.new debtor, bank_account, end_to_end_id(direct_debit), direct_debit.amount, "EUR"
      end

      creditor = Sepa::DirectDebitOrder::Party.new creditor.name, creditor.address, nil, creditor.postcode, creditor.town, creditor.country, creditor.contact, creditor.phone, creditor.email

      creditor_account = Sepa::DirectDebitOrder::BankAccount.new creditor.iban, creditor.bic

      payment = Sepa::DirectDebitOrder::CreditorPayment.new creditor, creditor_account, payment_identifier, collection_date, dd_list

      initiator = Sepa::DirectDebitOrder::Party.new initiator.identifier, initiator.address, nil, initiator.postcode, initiator.town, initiator.country, initiator.contact, initiator.phone, initiator.email

      order = Sepa::DirectDebitOrder::Order.new message_id, initiator, [payment]

      order.to_xml
    end

The last line returns a string that you will then need to send to your bank one way or another. For example, you might use an EBICS client.


## Contributing

Other message types are totally welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
