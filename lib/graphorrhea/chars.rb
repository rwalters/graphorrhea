require 'streamable'

class Graphorrhea::Chars
  Dictionary = ('a'..'z').to_a.freeze

  def initialize(sampler = Sampler.new)
    @sampler = sampler
  end

  def random
    sampler.call(Dictionary)
  end

  def stream
    CharStreamer.new(self).call
  end

  private
  attr_reader :sampler

  class CharStreamer
    include Streamable

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
