require 'spec_helper'

describe JsonCli do
  it 'should have a version number' do
    JsonCli::VERSION.should_not be_nil
  end
end
