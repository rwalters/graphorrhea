class Graphorrhea::Words
  attr_reader :sampler
  DefaultWordLength = (3..9)

  def self.call(num_to_take = nil)
    num_to_take = num_to_take.to_i
    num_to_take = 1 if num_to_take < 1

    new.stream.take(num_to_take)
  end

  def initialize(source = nil)
    @source  = source || Graphorrhea.config.char_source_proc.call
    @sampler = Graphorrhea.config.sampler
  end

  def call
    random
  end

  def random(word_size = nil)
    source.stream.take(sample(word_size)).join('')
  end

  def stream(word_size = nil)
    streamer.call(word_size)
  end

  private
  attr_reader :source

  def streamer
    Graphorrhea::Utils::Streamer.new(self)
  end

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
end
