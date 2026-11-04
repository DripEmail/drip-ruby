# frozen_string_literal: true

require_relative "release_tools/version"
require_relative "release_tools/changelog"
require_relative "release_tools/checks"

module ReleaseTools
  class Error < StandardError; end

  VERSION_CONSTANT = /VERSION = "([^"]*)"/

module_function

  def version_from_source(source)
    source[VERSION_CONSTANT, 1] or raise Error, "no VERSION constant found"
  end

  def with_version(source, version)
    raise Error, "no VERSION constant found" unless source.match?(VERSION_CONSTANT)

    source.sub(VERSION_CONSTANT, %(VERSION = "#{version}"))
  end

  def latest_version(tags) = tags.filter_map { |tag| Version.from_tag(tag) }.max

  def metadata(version_source, tag)
    version = Version.new(string: version_from_source(version_source))
    raise Error, "tag #{tag} does not match Drip::VERSION #{version.tag}" unless tag.nil? || tag == version.tag

    { "version" => version.to_s, "tag" => version.tag, "prerelease" => version.prerelease?.to_s }
  end
end
