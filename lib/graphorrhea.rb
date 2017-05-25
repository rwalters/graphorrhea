class Graphorrhea
  def self.word(letters = 5)
    letters = 5 if letters.to_i <= 0
    letters.times.map{ CHARS.sample }.join('')
  end

  private

  CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
end
