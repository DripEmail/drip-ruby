# frozen_string_literal: true

require "date"

module ReleaseTools
  module Changelog
    HEADING = /\A## \[([^\]]+)\](?: - (\d{4}-\d{2}-\d{2}))?\s*\z/
    UNRELEASED = "Unreleased"
    COMPARE_URL = "https://github.com/DripEmail/drip-ruby/compare"
    PREVIOUS_TAG = %r{\A#{Regexp.escape(COMPARE_URL)}/(v\S+)\.\.\.HEAD\z}

    Section = Data.define(:label, :date, :link, :body, :raw)
    Document = Data.define(:preamble, :sections)

  module_function

    def parse(text)
      preamble = text[/\A.*?(?=^## \[|\z)/m]
      sections = text.delete_prefix(preamble).split(/^(?=## \[)/).map { |chunk| parse_section(chunk) }
      Document.new(preamble:, sections:)
    end

    def render(document) = document.preamble + document.sections.map(&:raw).join

    def parse_section(raw)
      heading, *rest = raw.lines
      label, date = parse_heading(heading)
      pattern = link_pattern(label)
      link = rest.filter_map { |line| line[pattern, 1] }.first
      Section.new(label:, date:, link:, body: rest.grep_v(pattern).join.strip, raw:)
    end

    def parse_heading(heading)
      label, date = heading.match(HEADING)&.captures
      raise Error, "malformed CHANGELOG.md heading #{heading.strip.inspect}" unless label

      [label, date && Date.iso8601(date)]
    end

    def link_pattern(label) = /\A\[#{Regexp.escape(label)}\]: (\S+)\s*\z/

    def build_section(label, date, link, body)
      heading = date ? "## [#{label}] - #{date.iso8601}" : "## [#{label}]"
      parse_section("#{[heading, "[#{label}]: #{link}", body].reject(&:empty?).join("\n\n")}\n\n")
    end

    def compare(from, to) = "#{COMPARE_URL}/#{from}...#{to}"

    def find(document, label) = document.sections.find { |section| section.label == label }

    def unreleased(document)
      find(document, UNRELEASED) or raise Error, "CHANGELOG.md has no [#{UNRELEASED}] section"
    end

    def previous_tag(document)
      unreleased(document).link.to_s[PREVIOUS_TAG, 1] or
        raise Error, "[#{UNRELEASED}] link must be #{compare('<previous tag>', 'HEAD')}"
    end

    def nonempty(section)
      raise Error, "CHANGELOG.md section [#{section.label}] is empty" if section.body.empty?

      section
    end

    def release(text, version, date)
      raise Error, "prereleases do not get a CHANGELOG.md section" if version.prerelease?

      document = parse(text)
      current = nonempty(unreleased(document))
      released = released_sections(document, version, date)
      render(document.with(sections: document.sections.flat_map { |section| section.equal?(current) ? released : [section] }))
    end

    def released_sections(document, version, date)
      [
        build_section(UNRELEASED, nil, compare(version.tag, "HEAD"), ""),
        build_section(version.to_s, date, compare(previous_tag(document), version.tag), unreleased(document).body)
      ]
    end

    def notes_section(document, version)
      section = version.prerelease? ? unreleased(document) : find(document, version.to_s)
      section or raise Error, "CHANGELOG.md has no section for #{version}"
    end

    def notes(text, version)
      section = nonempty(notes_section(parse(text), version))
      raise Error, "CHANGELOG.md section [#{section.label}] has no compare link" unless section.link

      "#{section.body}\n\n**Full diff**: #{section.link.sub(/HEAD\z/, version.tag)}\n"
    end
  end
end
