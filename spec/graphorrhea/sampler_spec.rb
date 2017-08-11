require 'rspec'
require 'graphorrhea/sampler'

describe Graphorrhea::Sampler do
  subject { described_class.new(seed) }
  let(:seed) { 42 }
  let(:given_array) { [1, 2, 3, 4] }

  it "selects a random item from an array" do
    expect(given_array).to include(subject.call(given_array))
  end

  it "selects a single item from an array" do
    expect(subject.call(given_array)).to be_a(given_array.first.class)
  end

  it "selects different items on subsequent calls" do
    expect(subject.call(given_array)).not_to eq(subject.call(given_array))
  end
end
