require 'securerandom'

class Graphorrhea
  DefaultWordLength     = (3..9)
  DefaultWordCount      = 5
  DefaultSentenceCount  = 3

  class << self
    def word(num_letters = nil)
      @@inst ||= new
      @@inst.word(num_letters)
    end

    def words(num_words = nil, wlength = nil)
      @@inst ||= new
      @@inst.words(num_words, wlength)
    end

    def sentence(num_words = nil, wlength = nil)
      (words(num_words, wlength).join(' ') << '.').capitalize
    end

    def sentences(num_sentences = nil, slength = nil, wlength = nil)
      @@inst ||= new
      @@inst.sentences(num_sentences, slength, wlength)
    end
  end

  def initialize(seed = SecureRandom.random_number)
    @rng = Random.new(seed)
  end

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
    streamer { random_char }
  end

  def word_stream(wlength)
    streamer { word(wlength) }
  end

  def streamer(&block)
    Enumerator.new do |y|
      loop { y.yield block.call }
    end
  end

  LALPHAS = ('a'..'z').to_a.freeze
  UALPHAS = ('A'..'Z').to_a.freeze
  NUMBERS = (0..9).to_a
  CHARS   = LALPHAS.dup
end
