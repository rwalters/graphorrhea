require 'securerandom'
require 'dry-configurable'

require 'graphorrhea/streamable'
require 'graphorrhea/sampler'
require 'graphorrhea/words'
require 'graphorrhea/chars'
require 'graphorrhea/instance'

module Graphorrhea
  DefaultWordCount      = 5
  DefaultSentenceCount  = 3
  extend Dry::Configurable

  setting :sampler, Graphorrhea::Sampler.new
  setting :word_source_proc, ->{ Graphorrhea::Words.new }

  def self.word(num_letters = nil)
    Graphorrhea::Instance.word(num_letters)
  end

  def self.words(num_words = nil, wlength = nil)
    Graphorrhea::Instance.words(num_words, wlength)
  end

  def self.sentence(num_words = nil, wlength = nil)
    Graphorrhea::Instance.sentence(num_words, wlength)
  end

  def self.sentences(num_sentences = nil, slength = nil, wlength = nil)
    Graphorrhea::Instance.sentences(num_sentences, slength, wlength)
  end

  def self.instance(seed = nil)
    Graphorrhea::Instance.instance(seed)
  end
end
