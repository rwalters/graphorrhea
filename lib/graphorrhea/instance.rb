module Graphorrhea
  class Instance
    include Graphorrhea::Streamable

    class << self
      def word(num_letters = nil)
        self.instance.word(num_letters)
      end

      def words(num_words = nil, wlength = nil)
        self.instance.words(num_words, wlength)
      end

      def sentence(num_words = nil, wlength = nil)
        words(num_words, wlength).join(' ').capitalize << '.'
      end

      def sentences(num_sentences = nil, slength = nil, wlength = nil)
        self.instance.sentences(num_sentences, slength, wlength)
      end

      def instance(seed = nil)
        unless defined?(@@inst)
          @@inst = Hash.new{|h, k| seed = SecureRandom.random_number if k.nil?;h[k] = self.new(seed)}
        end

        if seed.nil?
          @@inst[seed]
        else
          @@inst[seed] = self.new(seed)
        end
      end
    end

    def initialize(seed)
      @sampler = Graphorrhea.config.sampler.class.new(seed)
      @word_source = Graphorrhea.config.word_source_proc.call
    end

    def sentences(num_sentences = nil, slength = nil, wlength = nil)
      num_sentences = DefaultSentenceCount if to_int(num_sentences) <= 0
      sample(num_sentences).times.map{ self.class.sentence(slength, wlength) }
    end

    def sentence(slength = nil, wlength = nil)
      sentence_source(wlength).random(slength)
    end

    def words(num_words = nil, wlength = nil)
      num_words = DefaultWordCount if to_int(num_words) <= 0
      word_stream(wlength).take(sample(num_words))
    end

    def word(num_letters = nil)
      word_source.random(num_letters)
    end

    private
    attr_reader :sampler, :word_source

    def to_int(input)
      return input.end if input.is_a?(Range)

      input.to_i
    end

    def random_char
      char_source.random
    end

    def sample(from_array)
      sampler.call(from_array)
    end

    def char_stream
      char_source.stream
    end

    def word_stream(wlength)
      word_source.stream(wlength)
    end

    def sentence_stream(wlength)
      sentence_source.stream(wlength)
    end

    def char_source
      @ch_source ||= Graphorrhea::Chars.new(sampler)
    end

    def sentence_source
      @s_source ||= Graphorrhea::Sentence.new(word_source)
    end

    class Sentences
      DefaultWordCount = 5
      def initialize(word_source = Graphorrhea::Words.new(char_source))
        @word_source = word_source
        @sampler = word_source.sampler
      end

      def random(word_num = DefaultWordCount)
        word_source.stream.take(sample(word_num)).join(' ').capitalize << '.'
      end

      private
      attr_reader :word_source

      def sample(to_test)
        sampler.call(scrub(to_test))
      end
    end
  end
end
