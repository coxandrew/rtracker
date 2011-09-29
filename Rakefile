require 'rake'
require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run all specs"
RSpec::Core::RakeTask.new('spec') do |spec|
  spec.pattern = 'spec/*spec.rb'
end

desc "Run the example"
task :status do
  ruby "-I lib bin/pivotaltracker status"
end