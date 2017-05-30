require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
    base_dir = Rake.application.original_dir

    t.pattern     = "spec/**/*_spec.rb"
    t.rspec_opts  = ["-I#{base_dir}/spec", "-c"]
    t.verbose     = false
end
