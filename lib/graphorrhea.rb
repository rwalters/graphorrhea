require 'securerandom'

class Graphorrhea
  DefaultWordLength     = 5
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
      words(num_words, wlength).join(' ') << '.'
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
    num_sentences = DefaultSentenceCount if num_sentences.to_i <= 0
    num_sentences.times.map{ self.class.sentence(sample(slength), wlength) }
  end

  def words(num_words = nil, wlength = nil)
    num_words = DefaultWordCount if num_words.to_i <= 0
    word_stream(wlength).take(num_words)
  end

  def word(num_letters = nil)
    num_letters = DefaultWordLength if num_letters.to_i <= 0
    char_stream.take(num_letters).join('')
  end

  private

  def random_char
    sample(CHARS)
  end

  def sample(from_array)
    Array(from_array).sample(random: @rng)
  end

  def char_stream
    Enumerator.new do |y|
      loop { y.yield random_char }
    end
  end

  def word_stream(wlength)
    Enumerator.new do |y|
      loop do
        y.yield word(sample(wlength))
      end
    end
  end

  CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
end
