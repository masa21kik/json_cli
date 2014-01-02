# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  # Unwind JSON class
  class UnwindJson
    def self.unwind_array(io, unwind_key, opt = {})
      opt[:out] ||= STDOUT
      io.each_line do |l|
        j = MultiJson.load(l.chomp)
        if j.key?(unwind_key) && j[unwind_key].is_a?(Array)
          j[unwind_key].each do |v|
            opt[:out].puts MultiJson.dump(j.merge(unwind_key => v))
          end
        else
          opt[:out].puts MultiJson.dump(j)
        end
      end
    end

    def self.unwind_hash(io, unwind_key, opt = {})
      opt[:out] ||= STDOUT
      opt[:key_label] ||= 'key'
      opt[:value_label] ||= 'value'
      io.each_line do |l|
        j = MultiJson.load(l.chomp)
        if j.key?(unwind_key) && j[unwind_key].is_a?(Hash)
          base = j.select { |k, v| k != unwind_key } if opt[:flatten]
          j[unwind_key].each do |k, v|
            if opt[:flatten]
              jj = base.merge(opt[:key_label] => k, opt[:value_label] => v)
            else
              jj = j.merge(unwind_key => { k => v })
            end
            opt[:out].puts MultiJson.dump(jj)
          end
        else
          opt[:out].puts MultiJson.dump(j)
        end
      end
    end
  end
end
