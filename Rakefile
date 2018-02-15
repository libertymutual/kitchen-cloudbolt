require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Display LOC stats'
task :loc do
  puts "\n## LOC Stats"
  sh 'countloc -r lib/kitchen'
end

desc 'Run RSpec unit tests'
RSpec::Core::RakeTask.new(:spec)

task default: [:loc, :spec]

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
