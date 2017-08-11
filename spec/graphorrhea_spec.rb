require 'spec_helper'

describe Graphorrhea do
  describe ".sentences" do
    subject { described_class.sentences }

    let(:default_count) { Graphorrhea::DefaultSentenceCount }

    it "generates three sentences" do
      expect(default_count).to eq 3
    end

    context "by default" do
      it "generates the default number of sentences" do
        expect(subject.count).to  be default_count
      end
    end

    context "with a sentence count specified" do
      subject { described_class.sentences(wcount) }

      context "with an explicit 'nil' count" do
        let(:wcount) { nil }

        it "returns default number of sentences" do
          expect(subject.count).to eq default_count
        end
      end

      context "with count of 0 specified" do
        let(:wcount) { 0 }

        it "returns default number of sentences" do
          expect(subject.count).to eq default_count
        end
      end

      context "with count of 10 specified" do
        let(:wcount) { 10 }

        it "returns ten sentences" do
          expect(subject.count).to eq wcount
        end
      end
    end

    context "with sentence length specified" do
      subject { described_class.sentences(5, words_per_sentence) }
      let(:words_per_sentence)    { 5 }
      let(:generated_words)       { subject.map{|i| i.sub(/\.$/, '').split(/ /)} }
      let(:generated_word_counts) { generated_words.map(&:count) }

      it "generates all sentences with that length" do
        expect(generated_word_counts.uniq).to match_array([words_per_sentence])
      end

      context "specify a range for the sentence length" do
        let(:words_per_sentence)  { wps_range }
        let(:wps_range)           { (6...66) }

        it "generates sentences of varying lengths" do
          expect(generated_word_counts.min).not_to eq(generated_word_counts.max)
        end

        it "generates sentences within the specified range" do
          # We have to 'splat' the array since 'cover' expects
          # '.to cover(1,2,3)' and not '.to cover([1,2,3])'
          expect(wps_range).to cover(*generated_word_counts)
        end
      end
    end

    context "with the word length specified" do
      subject { described_class.sentences(5, 5, wlength) }
      let(:wlength) { 9 }

      let(:generated_word_lengths)  { generated_words.flat_map{|w_array| w_array.map(&:length).uniq } }
      let(:generated_words)         { subject.map{|i| i.sub(/\.$/, '').split(/ /)} }

      it "generates all words with that length" do
        expect(generated_word_lengths.uniq).to match_array([wlength])
      end

      context "specify a range for the word length" do
        let(:wlength)   { wl_range }
        let(:wl_range)  { (6...66) }

        it "generates words of varying lengths" do
          expect(generated_word_lengths.min).not_to eq(generated_word_lengths.max)
        end

        it "generates words within the specified range" do
          # We have to 'splat' the array since 'cover' expects
          # '.to cover(1,2,3)' and not '.to cover([1,2,3])'
          expect(wl_range).to cover(*generated_word_lengths)
        end
      end
    end
  end

  describe ".sentence" do
    subject { described_class.sentence }

    let(:default_count) { Graphorrhea::DefaultWordCount }
    let(:words_in_sentence) { subject.split(/ /) }

    it "generates a five word sentence" do
      expect(default_count).to eq 5
    end

    it "initial upper case letter, the rest lower case, ends with a period" do
      expect(subject).to match(/^[A-Z]+[a-z\s]+\.$/)
    end

    context "by default" do
      it "generates the default numer of words" do
        expect(words_in_sentence.count).to  be default_count
      end
    end

    context "with a word count specified" do
      subject { described_class.sentence(wcount) }

      context "with an explicit 'nil' count" do
        let(:wcount) { nil }

        it "returns default number of words" do
          expect(words_in_sentence.count).to eq default_count
        end
      end

      context "with count of 0 specified" do
        let(:wcount) { 0 }

        it "returns default number of words" do
          expect(words_in_sentence.count).to eq default_count
        end
      end

      context "with count of 10 specified" do
        let(:wcount) { 10 }

        it "returns ten words" do
          expect(words_in_sentence.count).to eq wcount
        end
      end
    end

    context "with word length specified" do
      subject { described_class.sentence(5, word_length).tr('.', '') }
      let(:word_length)       { 12 }
      let(:generated_words)   { words_in_sentence.map(&:length) }

      it "generates all words with that length" do
        expect(generated_words.uniq).to match_array([word_length])
      end

      context "specify a range for the word length" do
        let(:word_length)       { word_length_range }
        let(:word_length_range) { (6...66) }

        it "generates words of varying lengths" do
          expect(generated_words.min).not_to eq(generated_words.max)
        end

        it "generates words within the specified range" do
          # We have to 'splat' the array since 'cover' expects
          # '.to cover(1,2,3)' and not '.to cover([1,2,3])'
          expect(word_length_range).to cover(*generated_words)
        end
      end
    end
  end

  describe ".word" do
    before do
      @old_proc = Graphorrhea.config.word_source_proc
      Graphorrhea.config.word_source_proc = -> { word_source }
    end
    after  { Graphorrhea.config.word_source_proc = @old_proc }

    subject { described_class.instance(177) }

    let(:num_letters) { 5 }
    let(:word_source) { Struct.new(:random).new(0) }

    it "calls the word source" do
      expect(word_source).to receive(:random).with(num_letters)
      subject.word(num_letters)
    end
  end

  describe ".words" do
    subject { described_class.words }

    let(:default_count) { Graphorrhea::DefaultWordCount }

    it "generates five words by default" do
      expect(default_count).to eq 5
    end

    context "by default" do
      it "generates the default numer of words" do
        expect(subject.count).to be default_count
        expect(subject.size).to be default_count
      end
    end

    context "with a word count specified" do
      subject { described_class.words(wcount) }

      context "with an explicit 'nil' count" do
        let(:wcount) { nil }

        it "returns default number of words" do
          expect(subject.count).to eq default_count
        end
      end

      context "with count of 0 specified" do
        let(:wcount) { 0 }

        it "returns default number of words" do
          expect(subject.count).to eq default_count
        end
      end

      context "with count of 10 specified" do
        let(:wcount) { 10 }

        it "returns ten words" do
          expect(subject.count).to eq wcount
        end
      end

      context "with count of 10000 specified" do
        let(:wcount) { 10000 }

        it "returns ten thousand words" do
          expect(subject.count).to eq wcount
        end
      end
    end

    context "with word length specified" do
      subject { described_class.words(5, word_length) }
      let(:word_length)       { 12 }
      let(:generated_words)   { subject.map(&:length) }

      it "generates words of that length" do
        expect(generated_words.uniq).to match_array([word_length])
      end

      context "specify a range for the word length" do
        let(:word_length)       { word_length_range }
        let(:word_length_range) { (6...66) }

        it "should return words of varying lengths" do
          expect(generated_words.min).not_to eq(generated_words.max)
        end

        it "should return words within the specified range" do
          # We have to 'splat' the array since 'cover' expects
          # '.to cover(1,2,3)' and not '.to cover([1,2,3])'
          expect(word_length_range).to cover(*generated_words)
        end
      end
    end
  end
end
