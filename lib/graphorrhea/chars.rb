require 'streamable'

class Graphorrhea::Chars
  include Streamable
  DICTIONARY = ('a'..'z').to_a.freeze

  def initialize(sampler)
    @sampler = sampler
  end

  def random
    sampler.call(DICTIONARY)
  end

  def stream
    super { random }
  end

  private
  attr_reader :sampler
end
