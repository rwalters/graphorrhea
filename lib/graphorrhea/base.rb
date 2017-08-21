module Graphorrhea
  class Base
    def self.call(num_to_take = nil)
      num_to_take = num_to_take.to_i
      num_to_take = 1 if num_to_take < 1

      new.stream.take(num_to_take)
    end

    def initialize(source = nil)
      @source  = source   || default_source
      @sampler = Graphorrhea.config.sampler
    end

    def call
      random
    end

    def random(sample_size = nil)
      source.stream.take(sample(sample_size)).join('')
    end

    def stream(sample_size = nil)
      streamer.call(sample_size)
    end

    private
    attr_reader :sampler
    attr_reader :source

    def default_source
      nil
    end

    def streamer
      Graphorrhea::Utils::Streamer.new(self)
    end

    def sample(to_test)
      post_scrub = scrub(to_test)
      sampler.call(post_scrub)
    end

    def scrub(sample_size)
      to_int(sample_size) <= 0 ? self.class.const_get(:DefaultSampleSize) : sample_size
    end

    def to_int(input)
      return input.end if input.is_a?(Range)

      input.to_i
    end
  end
end
