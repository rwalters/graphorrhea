require 'graphorrhea/base'
require 'graphorrhea/chars'
require 'graphorrhea/words'
require 'graphorrhea/sentences'

module Graphorrhea
  class Instance
    DefaultSampleSize  = 5
    include Graphorrhea::Utils::Streamable

    class << self
      def word(num_letters = nil)
        self.instance.word(num_letters)
      end

      def words(num_words = nil, wlength = nil)
        self.instance.words(num_words, wlength)
      end

      def sentence(num_words = nil, wlength = nil)
        self.instance.sentence(num_words, wlength)
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
      sample(num_sentences).times.map{ self.class.sentence(slength, wlength) }
    end

    def sentence(slength = nil, wlength = nil)
      sentence_source(wlength).random(slength)
    end

    def words(num_words = nil, wlength = nil)
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

    def sample(to_test)
      post_scrub = scrub(to_test)
      sampler.call(post_scrub)
    end

    def scrub(sample_size)
      to_int(sample_size) <= 0 ? self.class.const_get(:DefaultSampleSize) : sample_size
    end

    def to_int(input)
      return input.end if input.is_a?(Range)

      input.to_i
    end

    def word_stream(wlength)
      word_source.stream(wlength)
    end

    def sentence_stream(wlength)
      sentence_source.stream(wlength)
    end

    def sentence_source(word_len = nil)
      Graphorrhea.config.sentence_source_proc.call(word_len)
    end
  end
end
