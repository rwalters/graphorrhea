module Graphorrhea::Utils
  class Sampler
    def initialize(seed = nil)
      seed ||= SecureRandom.random_number
      @rng = Random.new(seed)
    end

    def call(from_array)
      Array(from_array).sample(random: rng)
    end


    private
    attr_reader :rng
  end
end
