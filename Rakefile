# frozen_string_literal: true

require "bundler/gem_helper"
require "rake/testtask"

gem_helper = Bundler::GemHelper.new(__dir__)

desc "Build the gem into pkg/"
task(:build) { gem_helper.build_gem }

desc "Build and install the gem into system gems"
task(:install) { gem_helper.install_gem }

require "rubocop/rake_task"
RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

desc "Run tests"
task default: %i[rubocop test]
