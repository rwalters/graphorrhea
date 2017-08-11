class Graphorrhea::Chars
  attr_reader :sampler
  Dictionary = ('a'..'z').to_a.freeze

  def initialize(sampler = Graphorrhea::Sampler.new)
    @sampler = sampler
  end

  def random
    sampler.call(Dictionary)
  end

  def stream
    CharStreamer.new(self).call
  end

  private

  class CharStreamer
    include Graphorrhea::Streamable

    def initialize(char_source = Graphorrhea::Chars.new)
      @char_source = char_source
    end

    def call
      stream { char_source.random }
    end

    private
    attr_reader :char_source
  end
end
