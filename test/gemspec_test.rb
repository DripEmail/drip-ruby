# frozen_string_literal: true

require_relative 'test_helper'
require "open3"
require "rubygems/package"
require "tmpdir"

class Drip::GemspecTest < Drip::TestCase
  ROOT = File.expand_path("..", __dir__)

  def gem_contents
    spec = Gem::Specification.load(File.join(ROOT, "drip-ruby.gemspec"))
    Dir.mktmpdir do |dir|
      path = File.join(dir, spec.file_name)
      Dir.chdir(ROOT) { Gem::Package.build(spec, false, false, path) }
      Gem::Package.new(path).contents.sort
    end
  end

  def tracked_lib_files
    out, status = Open3.capture2("git", "-C", ROOT, "ls-files", "-z", "lib")
    assert status.success?, "git ls-files failed"
    out.split("\x0").grep(/\.rb\z/)
  end

  should "package exactly the tracked lib files and top-level docs" do
    expected = (tracked_lib_files + %w[LICENSE.txt README.md CHANGELOG.md]).sort
    assert_equal expected, gem_contents
  end
end
