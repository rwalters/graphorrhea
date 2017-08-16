require "bundler/setup"
require "graphorrhea"

class TestSampler
  def call(ary)
    Array(ary).first
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do |example|
    if example.metadata[:test_sampler] == true
      Graphorrhea.config.sampler = TestSampler.new
    end
  end

  config.after(:each) do |example|
    Graphorrhea.config.sampler = Graphorrhea::Utils::Sampler.new
  end
end
