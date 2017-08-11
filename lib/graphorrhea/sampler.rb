class Graphorrhea::Sampler
  def initialize(seed = SecureRandom.random_number)
    @rng = Random.new(seed)
  end

  def call(from_array)
    Array(from_array).sample(random: rng)
  end

  private
  attr_reader :rng
end
