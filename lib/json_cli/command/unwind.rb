# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  module Command
    # Unwind JSON class
    class Unwind < Base
      def initialize(io, options)
        super(options)
        @io = io
        @unwind_key = options[:unwind_key]
        @flatten = options[:flatten]
        @key_label = options[:key_label] || 'key'
        @value_label = options[:value_label] || 'value'
      end

      def unwind_array
        @io.each do |line|
          obj = MultiJson.load(line.chomp)
          if !obj.key?(@unwind_key) || !obj[@unwind_key].is_a?(Array)
            @output.puts MultiJson.dump(obj)
          else
            unwind_array_obj(obj)
          end
        end
      end

      def unwind_hash
        @io.each do |line|
          obj = MultiJson.load(line.chomp)
          if !obj.key?(@unwind_key) || !obj[@unwind_key].is_a?(Hash)
            @output.puts MultiJson.dump(obj)
          elsif @flatten
            unwind_hash_obj_flatten(obj)
          else
            unwind_hash_obj(obj)
          end
        end
      end

      private

      def unwind_array_obj(obj)
        obj[@unwind_key].each do |val|
          @output.puts MultiJson.dump(obj.merge(@unwind_key => val))
        end
      end

      def unwind_hash_obj(obj)
        obj[@unwind_key].each do |key, val|
          jj = obj.merge(@unwind_key => { key => val })
          @output.puts MultiJson.dump(jj)
        end
      end

      def unwind_hash_obj_flatten(obj)
        base = obj.select { |key, _| key != @unwind_key }
        obj[@unwind_key].each do |key, val|
          jj = base.merge(
            @key_label => key,
            @value_label => val
          )
          @output.puts MultiJson.dump(jj)
        end
      end
    end
  end
end
