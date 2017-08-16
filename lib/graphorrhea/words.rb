class Graphorrhea::Words
  attr_reader :sampler
  DefaultWordLength = (3..9)

  def self.call(num_words = nil)
    num_words = num_words.to_i
    num_words = 1 if num_words < 1

    new.stream.take(num_words)
  end

  def initialize(char_source = nil)
    @char_source = char_source || Graphorrhea.config.char_source_proc.call
    @sampler = Graphorrhea.config.sampler
  end

  def random(word_size = nil)
    char_source.stream.take(sample(word_size)).join('')
  end

  def stream(word_size = nil)
    Stream.new(self).call(word_size)
  end

  private
  attr_reader :char_source

  def sample(to_test)
    post_scrub = scrub(to_test)
    sampler.call(post_scrub)
  end

  def scrub(word_size)
    to_int(word_size) <= 0 ? DefaultWordLength : word_size
  end

  def to_int(input)
    return input.end if input.is_a?(Range)

    input.to_i
  end

  class Stream
    include Graphorrhea::Utils::Streamable

    def initialize(word_source = nil)
      @word_source = word_source || Graphorrhea.config.word_source_proc.call
    end

    def call(word_size = nil)
      stream { word_source.random(word_size) }
    end

    private
    attr_reader :word_source
  end
end
