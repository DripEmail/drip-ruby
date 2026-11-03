# frozen_string_literal: true

require "rubygems"

module ReleaseTools
  VERSION_FORMAT = /\A\d+\.\d+\.\d+(?:\.(?:alpha|beta|rc)\d+)?\z/

  Version = Data.define(:string) do
    include Comparable

    def self.valid?(string) = VERSION_FORMAT.match?(string.to_s)

    def self.from_tag(tag)
      string = tag.to_s.delete_prefix("v")
      new(string:) if tag.to_s.start_with?("v") && valid?(string)
    end

    def initialize(string:)
      raise Error, "malformed version #{string.inspect}: expected X.Y.Z or X.Y.Z.(alpha|beta|rc)N" unless Version.valid?(string)

      super
    end

    def <=>(other) = gem_version <=> other.gem_version
    def gem_version = Gem::Version.new(string)
    def prerelease? = gem_version.prerelease?
    def tag = "v#{string}"
    def to_s = string
  end
end
