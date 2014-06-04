# -*- mode: ruby; coding: utf-8 -*-
require 'multi_json'

module JsonCli
  # Join JSON class
  class JoinJson
    def self.left_join(left_io, right_io, join_key, out = STDOUT)
      right = io2hash(right_io, join_key)
      left_io.each do |l|
        j = MultiJson.load(l.chomp)
        j.merge!(right[j[join_key]] || {}) if j.key?(join_key)
        out.puts MultiJson.dump(j)
      end
      out.flush
    end

    def self.right_join(left_io, right_io, join_key, out = STDOUT)
      left_join(right_io, left_io, join_key, out)
    end

    def self.inner_join(left_io, right_io, join_key, out = STDOUT)
      right = io2hash(right_io, join_key)
      left_io.each do |l|
        j = MultiJson.load(l.chomp)
        next if !j.key?(join_key) || !right.key?(j[join_key])
        out.puts MultiJson.dump(j.merge(right[j[join_key]]))
      end
      out.flush
    end

    def self.io2hash(io, key)
      hash = {}
      io.each do |l|
        j = MultiJson.load(l.chomp)
        next unless j.key?(key)
        hash[j[key]] = j.select { |k, _| k != key }
      end
      hash
    end
  end
end
