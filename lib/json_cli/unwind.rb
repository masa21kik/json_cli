# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  # Unwind JSON class
  class UnwindJson
    def self.unwind_array(io, unwind_key, opt = {})
      opt[:out] ||= STDOUT
      io.each do |line|
        obj = MultiJson.load(line.chomp)
        if obj.key?(unwind_key) && obj[unwind_key].is_a?(Array)
          obj[unwind_key].each do |val|
            opt[:out].puts MultiJson.dump(obj.merge(unwind_key => val))
          end
        else
          opt[:out].puts MultiJson.dump(obj)
        end
      end
    end

    def self.unwind_hash(io, unwind_key, opt = {})
      opt[:out] ||= STDOUT
      opt[:key_label] ||= 'key'
      opt[:value_label] ||= 'value'
      io.each do |line|
        obj = MultiJson.load(line.chomp)
        if obj.key?(unwind_key) && obj[unwind_key].is_a?(Hash)
          base = obj.select { |_k, _| _k != unwind_key } if opt[:flatten]
          obj[unwind_key].each do |key, val|
            if opt[:flatten]
              jj = base.merge(opt[:key_label] => key, opt[:value_label] => val)
            else
              jj = obj.merge(unwind_key => { key => val })
            end
            opt[:out].puts MultiJson.dump(jj)
          end
        else
          opt[:out].puts MultiJson.dump(obj)
        end
      end
    end
  end
end
