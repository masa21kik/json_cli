# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  module Command
    # Join JSON class
    class Join < Base
      def initialize(left_io, right_io, options)
        super(options)
        @left_io = left_io
        @right_io = right_io
        @join_key = options[:join_key]
      end

      def left_join
        join(@left_io, @right_io)
      end

      def right_join
        join(@right_io, @left_io)
      end

      def inner_join
        right = io2hash(@right_io)
        @left_io.each do |line|
          obj = MultiJson.load(line.chomp)
          next if !obj.key?(@join_key) ||
            !right.key?((jk_val = obj[@join_key]))
          @output.puts MultiJson.dump(obj.merge(right[jk_val]))
        end
      end

      private

      def io2hash(io)
        io.each_with_object({}) do |line, hash|
          obj = MultiJson.load(line.chomp)
          hash[obj.delete(@join_key)] = obj if obj.key?(@join_key)
        end
      end

      def join(left_io, right_io)
        right = io2hash(right_io)
        left_io.each do |line|
          obj = MultiJson.load(line.chomp)
          obj.merge!(right[obj[@join_key]] || {}) if obj.key?(@join_key)
          @output.puts MultiJson.dump(obj)
        end
      end
    end
  end
end
