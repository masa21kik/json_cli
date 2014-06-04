require 'spec_helper'

describe JsonCli::JoinJson do
  describe '#left_join' do
    context 'when normal file input' do
      it 'joins right to left' do
        @left_io = File.open('spec/logfile.json', 'r')
        @right_io = File.open('spec/attribute.json', 'r')
        key = '_id'
        result = StringIO.new
        JsonCli::JoinJson.left_join(@left_io, @right_io, key, result)
        lines = result.string.each_line.to_a.map { |l| l.chomp }
        expect(lines.size).to eq(4)
        expect(lines[0]).to eq(%q({"_id":"0001","timestamp":1385273700,) +
          %q("tags":["news","sports"],"words":{"baseball":3,"soccer":2,) +
          %q("ichiro":1,"honda":2},"title":"A","authors":["alice"]}))
        expect(lines[1]).to eq(%q({"_id":"0002","timestamp":1385273730,) +
          %q("tags":["sports"],"words":{"sumo":3,"tennis":1,"japan":2},) +
          %q("title":"B","authors":["bob","john"]}))
        expect(lines[2]).to eq(%q({"_id":"0003","timestamp":1385274100,) +
          %q("tags":["drama"],"words":{"furuhata":2,"ichiro":3}}))
        expect(lines[3]).to eq(%q({"broken":"data"}))
      end
    end

    context 'when left is empty' do
      it 'outputs nothing' do
        @left_io = File.open('spec/empty.json', 'r')
        @right_io = File.open('spec/attribute.json', 'r')
        key = '_id'
        result = StringIO.new
        JsonCli::JoinJson.left_join(@left_io, @right_io, key, result)
        lines = result.string.each_line.to_a.map { |l| l.chomp }
        expect(lines).to be_empty
      end
    end

    context 'when right is empty' do
      it 'outputs just left' do
        @left_io = File.open('spec/logfile.json', 'r')
        @right_io = File.open('spec/empty.json', 'r')
        key = '_id'
        result = StringIO.new
        JsonCli::JoinJson.left_join(@left_io, @right_io, key, result)
        lines = result.string.each_line.to_a.map { |l| l.chomp }
        @left_io.rewind
        left_lines = @left_io.each.to_a.map { |l| l.chomp }
        expect(lines).to eq(left_lines)
      end
    end
  end

  describe '#right_join' do
    context 'when normal file input' do
      it 'joins left to right' do
        @left_io = File.open('spec/logfile.json', 'r')
        @right_io = File.open('spec/attribute.json', 'r')
        key = '_id'
        result = StringIO.new
        JsonCli::JoinJson.right_join(@left_io, @right_io, key, result)
        lines = result.string.each_line.to_a.map { |l| l.chomp }
        expect(lines.size).to eq(3)
        expect(lines[0]).to eq(%q({"_id":"0001","title":"A",) +
          %q("authors":["alice"],"timestamp":1385273700,) +
          %q("tags":["news","sports"],"words":{"baseball":3,) +
          %q("soccer":2,"ichiro":1,"honda":2}}))
        expect(lines[1]).to eq(%q({"_id":"0002","title":"B",) +
          %q("authors":["bob","john"],"timestamp":1385273730,) +
          %q("tags":["sports"],"words":{"sumo":3,"tennis":1,"japan":2}}))
        expect(lines[2]).to eq(%q({"_id":"0004","title":"D",) +
          %q("authors":["dave"]}))
      end
    end
  end

  describe '#inner_join' do
    context 'when normal file input' do
      it 'joins inner' do
        @left_io = File.open('spec/logfile.json', 'r')
        @right_io = File.open('spec/attribute.json', 'r')
        key = '_id'
        result = StringIO.new
        JsonCli::JoinJson.inner_join(@left_io, @right_io, key, result)
        lines = result.string.each_line.to_a.map { |l| l.chomp }
        expect(lines.size).to eq(2)
        expect(lines[0]).to eq(%q({"_id":"0001","timestamp":1385273700,) +
          %q("tags":["news","sports"],"words":{"baseball":3,"soccer":2,) +
          %q("ichiro":1,"honda":2},"title":"A","authors":["alice"]}))
        expect(lines[1]).to eq(%q({"_id":"0002","timestamp":1385273730,) +
          %q("tags":["sports"],"words":{"sumo":3,"tennis":1,"japan":2},) +
          %q("title":"B","authors":["bob","john"]}))
      end
    end

    context 'when right is empty' do
      it 'outputs nothing' do
        @left_io = File.open('spec/logfile.json', 'r')
        @right_io = File.open('spec/empty.json', 'r')
        key = '_id'
        result = StringIO.new
        JsonCli::JoinJson.inner_join(@left_io, @right_io, key, result)
        lines = result.string.each_line.to_a.map { |l| l.chomp }
        expect(lines).to be_empty
      end
    end
  end

  after do
    @left_io.close if @left_io
    @right_io.close if @right_io
  end
end
