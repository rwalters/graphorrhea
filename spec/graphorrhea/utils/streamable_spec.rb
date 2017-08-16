require 'spec_helper'

class TestStream
  include Graphorrhea::Utils::Streamable
end

describe Graphorrhea::Utils::Streamable do
  subject { TestStream.new }
  let(:incrementer)   { a=1;subject.stream{ a += 2 } }
  let(:missing_block) { subject.stream }

  it "creates an Enumerator" do
    expect(incrementer).to be_a(Enumerator)
  end

  it "streams numbers" do
    expect(incrementer.take(3)).to match_array([3,5,7])
  end

  it "requires a block" do
    expect{ missing_block }.to raise_error(Graphorrhea::Utils::Streamable::NoBlockError)
  end
end
