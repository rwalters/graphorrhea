require 'spec_helper'

describe Graphorrhea::Chars, :test_sampler do
  let(:dictionary) { described_class::Dictionary }
  let(:sampler)    { TestSampler.new }

  describe "::Dictionary" do
    subject { dictionary }

    it "is an array" do
      expect(subject).to be_an(Array)
    end

    it "is all lower case characters" do
      expect(subject.join('')).to match(/^[a-z]+$/)
    end
  end

  describe "#random" do
    subject { described_class.new.random }

    it "returns the item Sampler selects from the dictionary" do
      expect(subject).to eq(sampler.call(dictionary))
    end
  end

  describe "#stream" do
    subject { described_class.new.stream }

    it "returns an array of items from the dictionary" do
      expect(subject.take(2)).to eq([sampler.call(dictionary), sampler.call(dictionary)])
    end
  end
end
