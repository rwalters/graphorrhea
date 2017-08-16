module Graphorrhea
  class Words < Base
    DefaultSampleSize = (3..9)

    private

    def default_source
      Graphorrhea.config.char_source_proc.call
    end

    def scrub(word_size)
      to_int(word_size) <= 0 ? DefaultSampleSize : word_size
    end
  end
end
