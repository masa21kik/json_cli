# JsonCli

JSON command line tools.

## Installation

Add this line to your application's Gemfile:

    gem 'json_cli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_cli

## Usage

Join attributes where key is '_id'

    $ cat logfile.json | json_cli left_join attribute.json -k _id

Unwind array or object

    $ cat logfile.json | json_cli unwind -k tags

Select or ignore keys

    $ cat logfile.json | json_cli select -k _id,tags

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
