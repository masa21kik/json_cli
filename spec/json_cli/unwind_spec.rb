# -*- mode: ruby; coding: utf-8 -*-
require 'spec_helper'

describe JsonCli::UnwindJson do
  describe '#unwind_array' do
    context 'when normal file input' do
      it 'unwinds array values' do
        @io = File.open('spec/logfile.json', 'r')
        key = 'tags'
        result = StringIO.new
        JsonCli::UnwindJson.unwind_array(@io, key, :out => result)
        lines = result.string.each_line.to_a.map{|l| l.chomp}
        expect(lines.size).to eq(5)
        expect(lines[0]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":"news","words":{"baseball":3,"soccer":2,"ichiro":1,"honda":2}}!)
        expect(lines[1]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":"sports","words":{"baseball":3,"soccer":2,"ichiro":1,"honda":2}}!)
        expect(lines[2]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":"sports","words":{"sumo":3,"tennis":1,"japan":2}}!)
        expect(lines[3]).to eq(%q!{"_id":"0003","timestamp":1385274100,"tags":"drama","words":{"furuhata":2,"ichiro":3}}!)
        expect(lines[4]).to eq(%q!{"broken":"data"}!)
      end
    end
  end

  describe '#unwind_array' do
    context 'when normal file input' do
      it 'unwinds hash values without flatten' do
        @io = File.open('spec/logfile.json', 'r')
        key = 'words'
        result = StringIO.new
        JsonCli::UnwindJson.unwind_hash(@io, key, :out => result)
        lines = result.string.each_line.to_a.map{|l| l.chomp}
        expect(lines.size).to eq(10)
        expect(lines[0]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"words":{"baseball":3}}!)
        expect(lines[1]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"words":{"soccer":2}}!)
        expect(lines[2]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"words":{"ichiro":1}}!)
        expect(lines[3]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"words":{"honda":2}}!)
        expect(lines[4]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":["sports"],"words":{"sumo":3}}!)
        expect(lines[5]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":["sports"],"words":{"tennis":1}}!)
        expect(lines[6]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":["sports"],"words":{"japan":2}}!)
        expect(lines[7]).to eq(%q!{"_id":"0003","timestamp":1385274100,"tags":["drama"],"words":{"furuhata":2}}!)
        expect(lines[8]).to eq(%q!{"_id":"0003","timestamp":1385274100,"tags":["drama"],"words":{"ichiro":3}}!)
        expect(lines[9]).to eq(%q!{"broken":"data"}!)
      end

      it 'unwinds hash values with flatten' do
        @io = File.open('spec/logfile.json', 'r')
        key = 'words'
        result = StringIO.new
        JsonCli::UnwindJson.unwind_hash(@io, key, :out => result, :flatten => true, :key_label => 'word', :value_label => 'count')
        lines = result.string.each_line.to_a.map{|l| l.chomp}
        expect(lines.size).to eq(10)
        expect(lines[0]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"word":"baseball","count":3}!)
        expect(lines[1]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"word":"soccer","count":2}!)
        expect(lines[2]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"word":"ichiro","count":1}!)
        expect(lines[3]).to eq(%q!{"_id":"0001","timestamp":1385273700,"tags":["news","sports"],"word":"honda","count":2}!)
        expect(lines[4]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":["sports"],"word":"sumo","count":3}!)
        expect(lines[5]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":["sports"],"word":"tennis","count":1}!)
        expect(lines[6]).to eq(%q!{"_id":"0002","timestamp":1385273730,"tags":["sports"],"word":"japan","count":2}!)
        expect(lines[7]).to eq(%q!{"_id":"0003","timestamp":1385274100,"tags":["drama"],"word":"furuhata","count":2}!)
        expect(lines[8]).to eq(%q!{"_id":"0003","timestamp":1385274100,"tags":["drama"],"word":"ichiro","count":3}!)
        expect(lines[9]).to eq(%q!{"broken":"data"}!)
      end
    end
  end
end
