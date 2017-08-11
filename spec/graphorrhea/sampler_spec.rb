require 'spec_helper'

shared_examples "selecting from array" do
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

describe Graphorrhea::Sampler do
  context "without a seed" do
    subject { described_class.new }
    let(:given_array) { [1, 2, 3, 4] }

    it_behaves_like "selecting from array"
  end

  context "when given a seed" do
    subject { described_class.new(seed) }
    let(:seed) { 42 }
    let(:given_array) { [1, 2, 3, 4] }

    it_behaves_like "selecting from array"

    context "the same seed in two instances" do
      let(:run1) { described_class.new(seed) }
      let(:run2) { described_class.new(seed) }

      it "each instance selects an identical sequence of items" do
        expect(5.times{ run1.call(given_array) }).to eq(5.times{ run2.call(given_array) })
      end
    end

    context "a nil seed" do
      let(:seed) { nil }

      it_behaves_like "selecting from array"
    end
  end
end
