require 'rspec'
require 'graphorrhea'

class TestSampler
  def call(ary)
    ary.first
  end
end

describe Graphorrhea::Chars do
  let(:dictionary) { described_class::Dictionary }

  describe "::Dictionary" do
    subject { described_class::Dictionary }

    it "is an array" do
      expect(subject).to be_an(Array)
    end

    it "is all lower case characters" do
      expect(subject.join('')).to match(/^[a-z]+$/)
    end
  end

  describe "#random" do
    subject { described_class.new(sampler).random }

    let(:sampler) { TestSampler.new }

    it "returns the item Sampler selects from the dictionary" do
      expect(subject).to eq(sampler.call(dictionary))
    end
  end

  describe "#stream" do
    subject { described_class.new(sampler).stream }

    let(:sampler) { TestSampler.new }

    it "returns an array of items from the dictionary" do
      expect(subject.take(2)).to eq([sampler.call(dictionary), sampler.call(dictionary)])
    end
  end
end
