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


## Contributing

Other message types are totally welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
