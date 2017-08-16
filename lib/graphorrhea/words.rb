module Graphorrhea
  class Words < Base
    DefaultSampleSize = (3..9)

    private

    def default_source
      Graphorrhea.config.char_source_proc.call
    end
  end
end
