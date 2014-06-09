require 'thor'

module JsonCli
  # CLI class
  class CLI < Thor
    class_option :output, aliases: :o, default: '/dev/stdout'

    desc 'left_join', 'left outer join of json files'
    option :join_key, required: true, aliases: :k
    option :join_file, required: true,  aliases: :j
    option :base_file, aliases: :b, default: '/dev/stdin'
    def left_join
      join_common(__method__)
    end

    desc 'right_join', 'right outer join of json files'
    option :join_key, required: true, aliases: :k
    option :join_file, required: true,  aliases: :j
    option :base_file, aliases: :b, default: '/dev/stdin'
    def right_join
      join_common(__method__)
    end

    desc 'inner_join', 'inner join of json files'
    option :join_key, required: true, aliases: :k
    option :join_file, required: true,  aliases: :j
    option :base_file, aliases: :b, default: '/dev/stdin'
    def inner_join
      join_common(__method__)
    end

    desc 'unwind_array [JSON_FILE]', 'unwind array of json file'
    option :unwind_key, required: true, aliases: :k
    def unwind_array(json_file = '/dev/stdin')
      unwind_common(__method__, json_file)
    end

    desc 'unwind_hash [JSON_FILE]', 'unwind hash of json file'
    option :unwind_key, required: true, aliases: :k
    option :flatten, type: :boolean, aliases: :f
    option :key_label
    option :value_label
    def unwind_hash(json_file = '/dev/stdin')
      unwind_common(__method__, json_file)
    end

    private

    def join_common(command)
      left_io = File.open(options[:base_file], 'r')
      right_io = File.open(options[:join_file], 'r')
      JsonCli::Command::Join.new(left_io, right_io, opts).send(command)
      [left_io, right_io, opts[:out]].each(&:close)
    end

    def unwind_common(command, json_file)
      io = File.open(json_file, 'r')
      JsonCli::Command::Unwind.new(io, opts).send(command)
      [io, opts[:out]].each(&:close)
    end

    def opts
      @opts ||= { out: File.open(options[:output], 'w') }
        .merge(options.select { |key, _| key != :output })
        .each_with_object({}) do |(key, val), hash|
        hash[key.to_sym] = val
      end
    end
  end
end
