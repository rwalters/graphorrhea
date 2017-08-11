module Graphorrhea::Streamable
  class NoBlockError < ArgumentError
    def initialize(msg = "Block required for streaming")
      super
    end
  end

  def stream(&block)
    raise NoBlockError unless block_given?

    Enumerator.new do |y|
      loop { y.yield block.call }
    end
  end
end
