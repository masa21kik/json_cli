# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  # Join JSON class
  class JoinJson
    def self.left_join(left_io, right_io, join_key, out = STDOUT)
      right = io2hash(right_io, join_key)
      left_io.each do |line|
        obj = MultiJson.load(line.chomp)
        obj.merge!(right[obj[join_key]] || {}) if obj.key?(join_key)
        out.puts MultiJson.dump(obj)
      end
    end

    def self.right_join(left_io, right_io, join_key, out = STDOUT)
      left_join(right_io, left_io, join_key, out)
    end

    def self.inner_join(left_io, right_io, join_key, out = STDOUT)
      right = io2hash(right_io, join_key)
      left_io.each do |line|
        obj = MultiJson.load(line.chomp)
        next if !obj.key?(join_key) || !right.key?((jk_val = obj[join_key]))
        out.puts MultiJson.dump(obj.merge(right[jk_val]))
      end
    end

    def self.io2hash(io, join_key)
      io.each_with_object({}) do |line, hash|
        obj = MultiJson.load(line.chomp)
        hash[obj.delete(join_key)] = obj if obj.key?(join_key)
      end
    end
  end
end
