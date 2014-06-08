#!/usr/bin/env ruby
require 'json_cli'
require 'thor'

module JsonCli
  # CLI class
  class CLI < Thor
    class_option :output, aliases: :o, default: '/dev/stdout'

    desc 'left_join RIGHT_FILE [LEFT_FILE]', 'left outer join of json files'
    option :join_key, required: true, aliases: :k
    def left_join(right_file, left_file = '/dev/stdin')
      left_io = File.open(left_file, 'r')
      right_io = File.open(right_file, 'r')
      JsonCli::Command::Join.left_join(left_io, right_io, opts)
      [left_io, right_io, opts[:out]].each(&:close)
    end

    desc 'right_join RIGHT_FILE [LEFT_FILE]', 'right outer join of json files'
    option :join_key, required: true, aliases: :k
    def right_join(right_file, left_file = '/dev/stdin')
      left_io = File.open(left_file, 'r')
      right_io = File.open(right_file, 'r')
      JsonCli::Command::Join.right_join(left_io, right_io, opts)
      [left_io, right_io, opts[:out]].each(&:close)
    end

    desc 'inner_join RIGHT_FILE [LEFT_FILE]', 'inner join of json files'
    option :join_key, required: true, aliases: :k
    def inner_join(right_file, left_file = '/dev/stdin')
      left_io = File.open(left_file, 'r')
      right_io = File.open(right_file, 'r')
      JsonCli::Command::Join.inner_join(left_io, right_io, opts)
      [left_io, right_io, opts[:out]].each(&:close)
    end

    desc 'unwind_array [JSON_FILE]', 'unwind array of json file'
    option :unwind_key, required: true, aliases: :k
    def unwind_array(json_file = '/dev/stdin')
      io = File.open(json_file, 'r')
      JsonCli::Command::Unwind.unwind_array(io, opts)
      [io, opts[:out]].each(&:close)
    end

    desc 'unwind_hash [JSON_FILE]', 'unwind hash of json file'
    option :unwind_key, required: true, aliases: :k
    option :flatten, type: :boolean, aliases: :f
    option :key_label
    option :value_label
    def unwind_hash(json_file = '/dev/stdin')
      io = File.open(json_file, 'r')
      JsonCli::Command::Unwind.unwind_hash(io, opts)
      [io, opts[:out]].each(&:close)
    end

    private

    def opts
      @opts ||= { out: File.open(options[:output], 'w') }
        .merge(options.select { |key, _| key != :output })
        .each_with_object({}) do |(key, val), hash|
        hash[key.to_sym] = val
      end
    end
  end
end

JsonCli::CLI.start(ARGV)
