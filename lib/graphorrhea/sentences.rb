module Graphorrhea
  class Sentences < Base
    attr_accessor :word_length
    DefaultSampleSize = (5..9)

    def initialize(*args)
      super
      @word_length = nil
    end

    def random(sample_size = nil)
      source_stream.take(sample(sample_size)).join(' ').capitalize << '.'
    end

    private

    def source_stream
      source.stream(word_length)
    end

    def default_source
      Graphorrhea.config.word_source_proc.call
    end
  end
end
