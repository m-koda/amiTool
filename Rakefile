require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

desc "Run unit and integration tests"
task :spec => ["spec:unit", "spec:integration"]

namespace :spec do
  RSpec::Core::RakeTask.new("unit") do |task|
    task.pattern = "./spec/unit{,/*/**}/*_spec.rb"
  end

  RSpec::Core::RakeTask.new("integration") do |task|
    task.pattern = "./spec/integration{,/*/**}/*_spec.rb"
  end
end

# RuboCop::RakeTask.new(:rubocop) do |task|
#   task.patterns = %w(lib/**/*.rb spec/unit/**/*.rb)
# end