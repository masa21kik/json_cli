# -*- mode: ruby; coding: utf-8 -*-
require 'spec_helper'

describe JsonCli::UnwindJson do
  shared_examples_for 'unwind json' do
    it 'unwind json as expected' do
      @io = File.open(File.join(FIXTURE_DIR, input_file))
      expect_file_path = File.join(FIXTURE_DIR, expect_file)
      result = StringIO.new
      opts = options.merge(out: result, unwind_key: unwind_key)
      JsonCli::UnwindJson.send(command, @io, opts)
      expect(result.string).to eq File.read(expect_file_path)
    end

    after do
      @io.close if @io
    end
  end

  describe '#unwind_array' do
    let(:command) { 'unwind_array' }

    context 'when normal file input' do
      let(:input_file) { 'logfile.json' }
      let(:unwind_key) { 'tags' }
      let(:options) { {} }
      let(:expect_file) { 'unwind_logfile_tags.json' }
      it_behaves_like 'unwind json'
    end
  end

  describe '#unwind_hash' do
    let(:command) { 'unwind_hash' }

    context 'when normal file input' do
      let(:input_file) { 'logfile.json' }
      let(:unwind_key) { 'words' }
      let(:options) { {} }
      let(:expect_file) { 'unwind_logfile_words.json' }
      it_behaves_like 'unwind json'
    end

    context 'when normal file input with flatten option' do
      let(:input_file) { 'logfile.json' }
      let(:unwind_key) { 'words' }
      let(:expect_file) { 'unwind_logfile_words_flatten.json' }
      let(:options) do
        { flatten: true, key_label: 'word', value_label: 'count' }
      end
      it_behaves_like 'unwind json'
    end
  end
end
