require 'securerandom'
require 'streamable'

class Graphorrhea
  include Streamable

  DefaultWordLength     = (3..9)
  DefaultWordCount      = 5
  DefaultSentenceCount  = 3

  class << self
    def word(num_letters = nil)
      self.new.word(num_letters)
    end

    def words(num_words = nil, wlength = nil)
      self.new.words(num_words, wlength)
    end

    def sentence(num_words = nil, wlength = nil)
      (words(num_words, wlength).join(' ') << '.').capitalize
    end

    def sentences(num_sentences = nil, slength = nil, wlength = nil)
      self.new.sentences(num_sentences, slength, wlength)
    end
  end

  def initialize(seed = nil)
    unless defined?(@@inst)
      @@inst = Hash.new{|h, k| h[k] = init(k) }
    end

    if seed.nil?
      @@inst[seed]
    else
      @@inst[seed] = init(seed)
    end
  end
  alias_method :init, :initialize

  def sentences(num_sentences = nil, slength = nil, wlength = nil)
    num_sentences = DefaultSentenceCount if to_int(num_sentences) <= 0
    sample(num_sentences).times.map{ self.class.sentence(slength, wlength) }
  end

  def words(num_words = nil, wlength = nil)
    num_words = DefaultWordCount if to_int(num_words) <= 0
    word_stream(wlength).take(sample(num_words))
  end

  def word(num_letters = nil)
    num_letters = DefaultWordLength if to_int(num_letters) <= 0
    char_stream.take(sample(num_letters)).join('')
  end

  private

  def init(seed = nil)
    seed = SecureRandom.random_number if seed.nil?
    @rng = Random.new(seed)
  end

  def to_int(input)
    return input.end if input.is_a?(Range)

    input.to_i
  end

  def random_char
    sample(CHARS)
  end

  def sample(from_array)
    Array(from_array).sample(random: @rng)
  end

  def char_stream
    stream { random_char }
  end

  def word_stream(wlength)
    stream { word(wlength) }
  end

  NUMBERS = (0..9).to_a.freeze
  CHARS   = ('a'..'z').to_a.freeze
end
