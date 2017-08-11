require 'rspec'
require 'graphorrhea'

class TestSampler
  def call(ary)
    Array(ary).first
  end
end

describe Graphorrhea::Words do
  let(:words) { described_class.new(char_source) }
  let(:char_source) { Graphorrhea::Chars.new(TestSampler.new) }

  describe "#random" do
    context "length of word returned" do
      subject { words.random }

      let(:default_length) { Graphorrhea::Words::DefaultWordLength }

      it "has a default word length of the range (3..9)" do
        expect(default_length).to eq (3..9)
      end

      context "by default" do
        it "returns a word within the range" do
          expect(default_length).to cover(subject.length)
        end
      end

      context "with a length specified" do
        subject { words.random(wlength) }

        context "with an explicit 'nil' length" do
          let(:wlength) { nil }

          it "returns a word within the range" do
            expect(default_length).to cover(subject.length)
          end
        end

        context "with length of 0 specified" do
          let(:wlength) { 0 }

          it "returns a word within the range" do
            expect(default_length).to cover(subject.length)
          end
        end

        context "with length of 10 specified" do
          let(:wlength) { 10 }

          it "returns a ten character word" do
            expect(subject.length).to eq wlength
          end
        end

        context "with length of 10000 specified" do
          let(:wlength) { 10000 }

          it "returns a 10000 character word" do
            expect(subject.length).to eq wlength
          end
        end
      end
    end

    context "content of word returned" do
      subject { described_class.new }

      context "without specifying a seed" do
        context "run twice in succession" do
          it "returns different words each time" do
            run1 = subject.random
            run2 = subject.random

            expect(run1).not_to eq run2
          end
        end
      end

      context "specifying a seed" do
        let(:run1) { described_class.new(source1).random }
        let(:run2) { described_class.new(source2).random }

        let(:source1) { Graphorrhea::Chars.new(Graphorrhea::Sampler.new(seed1)) }
        let(:source2) { Graphorrhea::Chars.new(Graphorrhea::Sampler.new(seed2)) }

        context "initialized with the same seed" do
          let(:seed1) { 1001 }
          let(:seed2) { 1001 }

          it "returns identical words each time" do
            expect(run1).to eq run2
          end
        end

        context "initialized with different seeds" do
          let(:seed1) { 42 }
          let(:seed2) { 1138 }

          it "returns different words each time" do
            expect(run1).not_to eq run2
          end
        end
      end
    end
  end

  describe "#stream" do
    subject { words.stream(wlength) }

    (3..12).to_a.each do |i|
      context "for a length of #{i}" do
        let(:wlength) { i }
        it "returns an array of words of the correct length" do
          expect(subject.take(i).map(&:size).uniq).to eq([i])
        end
      end
    end
  end
end
