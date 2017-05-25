require 'rspec'
require 'graphorrhea'

describe Graphorrhea do
  describe ".word" do
    subject { described_class.word(wlength) }
    let(:wlength) { nil }

    context "by default" do
      it "returns a five character word" do
        expect(subject.length).to eq 5
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
        expect(subject.length).to eq 5
      end
    end
  end
end
