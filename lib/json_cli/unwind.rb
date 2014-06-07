# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  # Unwind JSON class
  class UnwindJson
    def self.unwind_array(io, opt)
      io.each do |line|
        obj = MultiJson.load(line.chomp)
        if !obj.key?((uk = opt[:unwind_key])) || !obj[uk].is_a?(Array)
          opt[:out].puts MultiJson.dump(obj)
        else
          unwind_array_obj(obj, uk, opt)
        end
      end
    end

    def self.unwind_array_obj(obj, unwind_key, opt)
      obj[unwind_key].each do |val|
        opt[:out].puts MultiJson.dump(obj.merge(unwind_key => val))
      end
    end

    def self.unwind_hash(io, opt)
      io.each do |line|
        obj = MultiJson.load(line.chomp)
        if !obj.key?((uk = opt[:unwind_key])) || !obj[uk].is_a?(Hash)
          opt[:out].puts MultiJson.dump(obj)
        elsif opt[:flatten]
          unwind_hash_obj_flatten(obj, uk, opt)
        else
          unwind_hash_obj(obj, uk, opt)
        end
      end
    end

    def self.unwind_hash_obj(obj, unwind_key, opt)
      obj[unwind_key].each do |key, val|
        jj = obj.merge(unwind_key => { key => val })
        opt[:out].puts MultiJson.dump(jj)
      end
    end

    def self.unwind_hash_obj_flatten(obj, unwind_key, opt)
      base = obj.select { |key, _| key != unwind_key }
      obj[unwind_key].each do |key, val|
        jj = base.merge(opt[:key_label] => key, opt[:value_label] => val)
        opt[:out].puts MultiJson.dump(jj)
      end
    end
  end
end
