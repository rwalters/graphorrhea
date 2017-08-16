module Graphorrhea::Utils
  class Streamer
    include Graphorrhea::Utils::Streamable

    def initialize(source)
      @source = source
    end

    def call(sample_size = nil)
      stream { source.random(sample_size) }
    end

    private
    attr_reader :source
  end
end
