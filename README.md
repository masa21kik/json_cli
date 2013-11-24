# JsonCli

JSON command line tools.

[![Build Status](https://travis-ci.org/masa21kik/json_cli.png?branch=master)](https://travis-ci.org/masa21kik/json_cli)
[![Coverage Status](https://coveralls.io/repos/masa21kik/json_cli/badge.png)](https://coveralls.io/r/masa21kik/json_cli)
[![Code Climate](https://codeclimate.com/github/masa21kik/json_cli.png?branch=master)](https://codeclimate.com/github/masa21kik/json_cli)

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
