class Graphorrhea::Words
  attr_reader :sampler
  DefaultWordLength = (3..9)

  def initialize(char_source = Graphorrhea::Chars.new)
    @char_source = char_source
    @sampler = char_source.sampler
  end

  def random_array(num_words = nil, wlength = nil, word_source = self)
    word_source.stream(wlength).take(sample(num_words))
  end

  def random(word_size = nil)
    char_source.stream.take(sample(word_size)).join('')
  end

  def stream(word_size = nil)
    WordStream.new(self).call(word_size)
  end

  private
  attr_reader :char_source

  def sample(to_test)
    sampler.call(scrub(to_test))
  end

  def scrub(word_size)
    to_int(word_size) <= 0 ? DefaultWordLength : word_size
  end

  def to_int(input)
    return input.end if input.is_a?(Range)

    input.to_i
  end

  class WordStream
    include Graphorrhea::Streamable

    def initialize(word_source = Graphorrhea::Words.new)
      @word_source = word_source
    end

    def call(word_size)
      stream { word_source.random(word_size) }
    end

    private
    attr_reader :word_source
  end
end
