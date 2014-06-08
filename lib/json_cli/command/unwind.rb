# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  module Command
    # Unwind JSON class
    class Unwind
      def self.unwind_array(io, options)
        io.each do |line|
          obj = MultiJson.load(line.chomp)
          if !obj.key?((uk = options[:unwind_key])) || !obj[uk].is_a?(Array)
            options[:out].puts MultiJson.dump(obj)
          else
            unwind_array_obj(obj, uk, options)
          end
        end
      end

      def self.unwind_array_obj(obj, unwind_key, options)
        obj[unwind_key].each do |val|
          options[:out].puts MultiJson.dump(obj.merge(unwind_key => val))
        end
      end

      def self.unwind_hash(io, options)
        io.each do |line|
          obj = MultiJson.load(line.chomp)
          if !obj.key?((uk = options[:unwind_key])) || !obj[uk].is_a?(Hash)
            options[:out].puts MultiJson.dump(obj)
          elsif options[:flatten]
            unwind_hash_obj_flatten(obj, uk, options)
          else
            unwind_hash_obj(obj, uk, options)
          end
        end
      end

      def self.unwind_hash_obj(obj, unwind_key, options)
        obj[unwind_key].each do |key, val|
          jj = obj.merge(unwind_key => { key => val })
          options[:out].puts MultiJson.dump(jj)
        end
      end

      def self.unwind_hash_obj_flatten(obj, unwind_key, options)
        base = obj.select { |key, _| key != unwind_key }
        obj[unwind_key].each do |key, val|
          jj = base.merge(
            options[:key_label] => key,
            options[:value_label] => val
          )
          options[:out].puts MultiJson.dump(jj)
        end
      end
    end
  end
end
