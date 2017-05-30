require 'rspec'
require 'streamable'

class TestStream
  include Streamable
end

describe Streamable do
  subject { TestStream.new }
  let(:incrementer)   { a=1;subject.streamer{ a += 2 } }
  let(:missing_block) { subject.streamer }

  it "creates an Enumerator" do
    expect(incrementer).to be_a(Enumerator)
  end

  it "streams numbers" do
    expect(incrementer.take(3)).to match_array([3,5,7])
  end

  it "requires a block" do
    expect{ missing_block }.to raise_error(Streamable::NoBlockError)
  end
end