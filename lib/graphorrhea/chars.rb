class Graphorrhea::Chars
  Dictionary = ('a'..'z').to_a.freeze

  def self.call(num_to_take = nil)
    num_to_take = num_to_take.to_i
    num_to_take = 1 if num_to_take < 1

    new.stream.take(num_to_take)
  end

  def initialize(sampler = nil)
    @sampler = sampler || Graphorrhea.config.sampler
  end

  def call
    sampler.call(Dictionary)
  end

  def random(sample_size = nil)
    call
  end

  def stream
    streamer.call
  end

  private
  attr_reader :sampler

  def streamer
    Graphorrhea::Utils::Streamer.new(self)
  end
end
