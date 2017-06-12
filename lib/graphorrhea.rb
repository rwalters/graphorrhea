require 'securerandom'
require 'streamable'

class Graphorrhea
  include Streamable

  DefaultWordCount      = 5
  DefaultSentenceCount  = 3

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
    @sampler = Sampler.new(seed)
  end

  def sentences(num_sentences = nil, slength = nil, wlength = nil)
    num_sentences = DefaultSentenceCount if to_int(num_sentences) <= 0
    sample(num_sentences).times.map{ self.class.sentence(slength, wlength) }
  end

  def words(num_words = nil, wlength = nil)
    num_words = DefaultWordCount if to_int(num_words) <= 0
    word_source.stream(wlength).take(sample(num_words))
  end

  def word(num_letters = nil)
    word_source.random(num_letters)
  end

  private
  attr_reader :sampler

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

  def char_source
    @ch_source ||= Graphorrhea::Chars.new(sampler)
  end

  def word_source
    @w_source ||= Graphorrhea::Words.new(char_source, sampler)
  end

end

require 'sampler'
require 'graphorrhea/chars'
require 'graphorrhea/words'
