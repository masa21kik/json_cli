require 'spec_helper'
require 'tempfile'

describe JsonCli::CLI do
  let(:cli) { described_class.new }

  shared_examples_for 'cli' do
    before do
      @result_file = Tempfile.new(File.basename(__FILE__))
    end

    after do
      @result_file.close!
    end

    it 'output expected JSON' do
      args.map! { |f| File.join(FIXTURE_DIR, f) }
      options.merge!(output: @result_file.path)
      cli.invoke(command, args, options)
      expect_file_path = File.join(FIXTURE_DIR, expect_file)
      expect(File.read(@result_file.path)).to eq File.read(expect_file_path)
    end
  end

  context 'join' do
    describe '#left_join' do
      let(:args) { %w(attribute.json logfile.json) }
      let(:options) { { join_key: '_id' } }
      let(:command) { 'left_join' }
      let(:expect_file) { 'join_logfile_attribute_id.json' }
      it_behaves_like 'cli'
    end

    describe '#right_join' do
      let(:args) { %w(logfile.json attribute.json) }
      let(:options) { { join_key: '_id' } }
      let(:command) { 'right_join' }
      let(:expect_file) { 'join_logfile_attribute_id.json' }
      it_behaves_like 'cli'
    end

    describe '#inner_join' do
      let(:args) { %w(attribute.json logfile.json) }
      let(:options) { { join_key: '_id' } }
      let(:command) { 'inner_join' }
      let(:expect_file) { 'inner_join_logfile_attribute_id.json' }
      it_behaves_like 'cli'
    end
  end

  context 'unwind' do
    describe '#unwind_array' do
      let(:args) { %w(logfile.json) }
      let(:options) { { unwind_key: 'tags' } }
      let(:command) { 'unwind_array' }
      let(:expect_file) { 'unwind_logfile_tags.json' }
      it_behaves_like 'cli'
    end

    describe '#unwind_hash' do
      let(:args) { %w(logfile.json) }
      let(:options) { { unwind_key: 'words' } }
      let(:command) { 'unwind_hash' }
      let(:expect_file) { 'unwind_logfile_words.json' }
      it_behaves_like 'cli'
    end
  end
end
