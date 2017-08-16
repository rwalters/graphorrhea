module Graphorrhea
  class Chars < Base
    Dictionary = ('a'..'z').to_a.freeze

    def random(sample_size = nil)
      sampler.call(Dictionary)
    end
  end
end
