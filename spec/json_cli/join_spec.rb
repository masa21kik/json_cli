require 'spec_helper'

describe JsonCli::JoinJson do
  shared_examples_for 'join json' do
    it 'join json as expected' do
      @left_io = File.open(File.join(FIXTURE_DIR, left_file))
      @right_io = File.open(File.join(FIXTURE_DIR, right_file))
      expect_file_path = File.join(FIXTURE_DIR, expect_file)
      result = StringIO.new
      JsonCli::JoinJson.send(command, @left_io, @right_io, join_key, result)
      expect(result.string).to eq File.read(expect_file_path)
    end

    after do
      @left_io.close if @left_io
      @right_io.close if @right_io
    end
  end

  describe '#left_join' do
    let(:command) { 'left_join' }

    context 'when normal file input' do
      let(:left_file) { 'logfile.json' }
      let(:right_file) { 'attribute.json' }
      let(:join_key) { '_id' }
      let(:expect_file) { 'join_logfile_attribute_id.json' }
      it_behaves_like 'join json'
    end

    context 'when left is empty' do
      let(:left_file) { 'empty.json' }
      let(:right_file) { 'attribute.json' }
      let(:join_key) { '_id' }
      let(:expect_file) { 'empty.json' }
      it_behaves_like 'join json'
    end

    context 'when right is empty' do
      let(:left_file) { 'logfile.json' }
      let(:right_file) { 'empty.json' }
      let(:join_key) { '_id' }
      let(:expect_file) { 'logfile.json' }
      it_behaves_like 'join json'
    end
  end

  describe '#right_join' do
    let(:command) { 'right_join' }

    context 'when normal file input' do
      let(:left_file) { 'logfile.json' }
      let(:right_file) { 'attribute.json' }
      let(:join_key) { '_id' }
      let(:expect_file) { 'join_attribute_logfile_id.json' }
      it_behaves_like 'join json'
    end
  end

  describe '#inner_join' do
    let(:command) { 'inner_join' }

    context 'when normal file input' do
      let(:left_file) { 'logfile.json' }
      let(:right_file) { 'attribute.json' }
      let(:join_key) { '_id' }
      let(:expect_file) { 'inner_join_logfile_attribute_id.json' }
      it_behaves_like 'join json'
    end

    context 'when right is empty' do
      let(:left_file) { 'logfile.json' }
      let(:right_file) { 'empty.json' }
      let(:join_key) { '_id' }
      let(:expect_file) { 'empty.json' }
      it_behaves_like 'join json'
    end
  end
end
