require 'rspec'
require 'graphorrhea'

describe Graphorrhea do
  describe ".word" do
    context "length of word returned" do
      subject { described_class.word }

      let(:default_length) { Graphorrhea::DefaultWordLength }

      it "has a default word length of 5" do
        expect(default_length).to eq 5
      end

      context "by default" do
        it "returns a five character word" do
          expect(subject.length).to eq default_length
        end
      end

      context "with a length specified" do
        subject { described_class.word(wlength) }
        let(:wlength) { nil }

        context "with an explicit 'nil' length" do
          it "returns a five character word" do
            expect(subject.length).to eq default_length
          end
        end

        context "with length of 10 specified" do
          let(:wlength) { 10 }

          it "returns a ten character word" do
            expect(subject.length).to eq 10
          end
        end

        context "with length of 0 specified" do
          let(:wlength) { 0 }

          it "returns a five character word" do
            expect(subject.length).to eq default_length
          end
        end
      end
    end

    context "content of word returned" do
      subject { described_class }

      context "run twice in succession" do
        it "returns different words each time" do
          run1 = subject.word
          run2 = subject.word

          expect(run1).not_to eq run2
        end
      end

      context "initialized with the same seed" do
        it "returns identical words each time" do
          run1 = subject.new(1001).word
          run2 = subject.new(1001).word

          expect(run1).to eq run2
        end
      end
    end
  end
end
