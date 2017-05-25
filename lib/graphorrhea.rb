require 'securerandom'

class Graphorrhea
  DefaultWordLength = 5

  def initialize(seed = SecureRandom.random_number)
    @rng = Random.new(seed)
  end

  def self.word(letters = nil)
    @@inst ||= new
    @@inst.word(letters)
  end

  def word(letters = nil)
    letters = DefaultWordLength  if letters.to_i <= 0
    letters.times.map{ random_char }.join('')
  end

  private

  def random_char
    CHARS.sample(random: @rng)
  end

  CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
end
