# Sepa

An implementation of pain.008.001.04 CustomerDirectDebitInitiation.

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

The simplest way to generate a pain.008.001.04 xml message is to use the DirectDebitOrder module which exposes only the bare essentials. Which is still a lot, but hey, this is a banking standard, what do you expect.

Here's an example, ripped off from the spec, of a direct debit order for payments to a single creditor -

    direct_debits = []

    # for each direct debit you want to order ...

    for(each direct debit) do | ... |
      bank_account = Sepa::DirectDebitOrder::BankAccount.new iban, bic
      debtor = Sepa::DirectDebitOrder::Party.new name, addr, nil, postcode, town, country, contact, phone, email
      direct_debits << Sepa::DirectDebitOrder::DirectDebit.new debtor, bank_account, end_to_end_id, amount, "EUR"
    end

    creditor = Sepa::DirectDebitOrder::Party.new creditor_name, creditor_addr, nil, creditor_postcode, creditor_town, creditor_country, creditor_contact, creditor_phone, creditor_email

    creditor_account = Sepa::DirectDebitOrder::BankAccount.new creditor_iban, creditor_bic
    payment = Sepa::DirectDebitOrder::CreditorPayment.new creditor, creditor_account, payment_identifier, collection_date, direct_debits

    initiator = Sepa::DirectDebitOrder::Party.new initiator, initiator_addr, nil, initiator_postcode, initiator_town, initiator_country, initiator_contact, initiator_phone, initiator_email

    order = Sepa::DirectDebitOrder::Order.new message_identifier, initiator, [payment]

    order.to_xml

The last line returns a string that you will then need to send to your bank one way or another. For example, you might use an EBICS client.


## Contributing

Other message types are totally welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
