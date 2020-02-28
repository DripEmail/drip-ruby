# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

require "rubocop/rake_task"
RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

desc "Run tests"
task default: %i[rubocop test]
