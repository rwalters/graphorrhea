class Sampler
  def initialize(seed = nil)
    @rng = Random.new(seed)
  end

  def call(from_array)
    Array(from_array).sample(random: rng)
  end

  private
  attr_reader :rng
end
