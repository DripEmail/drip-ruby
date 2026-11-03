# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../rakelib/release_tools'

class ReleaseToolsTest < Drip::TestCase
  CHANGELOG = <<~MD
    # Changelog
    Intro.

    ## [Unreleased]

    [Unreleased]: https://github.com/DripEmail/drip-ruby/compare/v3.5.0...HEAD

    ### Fixed
    - A bug.

    ## [3.5.0] - 2026-07-10

    [3.5.0]: https://github.com/DripEmail/drip-ruby/compare/v3.4.2...v3.5.0

    ### Changed
    - Things.
  MD

  RELEASED = <<~MD
    # Changelog
    Intro.

    ## [Unreleased]

    [Unreleased]: https://github.com/DripEmail/drip-ruby/compare/v3.5.1...HEAD

    ## [3.5.1] - 2026-11-03

    [3.5.1]: https://github.com/DripEmail/drip-ruby/compare/v3.5.0...v3.5.1

    ### Fixed
    - A bug.

    ## [3.5.0] - 2026-07-10

    [3.5.0]: https://github.com/DripEmail/drip-ruby/compare/v3.4.2...v3.5.0

    ### Changed
    - Things.
  MD

  EMPTY_UNRELEASED = CHANGELOG.sub("### Fixed\n- A bug.\n\n", "")
  TODAY = Date.new(2026, 11, 3)

  def version(string) = ReleaseTools::Version.new(string:)

  def tag_facts(**overrides)
    ReleaseTools::Checks::TagFacts.new(branch: "main", clean: true, head: "abc", origin_main: "abc",
                                       version_source: %(VERSION = "3.5.0"\n), tags: %w[v3.4.2],
                                       published_versions: %w[3.4.2], changelog: CHANGELOG, today: TODAY, ci_conclusion: "success", **overrides)
  end

  def prepare_facts(**overrides)
    ReleaseTools::Checks::PrepareFacts.new(version: "3.5.1", branch: "release-3.5.1", clean: true, based_on_origin_main: true,
                                           tags: %w[v3.4.2 v3.5.0], changelog: CHANGELOG, **overrides)
  end

  context "Version" do
    should "accept final and prerelease versions" do
      %w[3.5.1 10.0.0 3.5.1.rc1 3.5.1.alpha2 3.5.1.beta10].each { |string| assert ReleaseTools::Version.valid?(string) }
    end

    should "reject other formats" do
      ["3.5", "v3.5.1", "3.5.1-rc1", "3.5.1.rc", "3.5.1.pre1", "", nil].each do |string|
        refute ReleaseTools::Version.valid?(string)
        assert_raises(ReleaseTools::Error) { version(string) }
      end
    end

    should "order prereleases before the final release" do
      assert_operator version("3.5.1.rc1"), :<, version("3.5.1")
      assert_operator version("3.5.1.rc2"), :>, version("3.5.1.rc1")
      assert_operator version("3.10.0"), :>, version("3.9.9")
    end

    should "know whether it is a prerelease and its tag" do
      assert version("3.5.1.rc1").prerelease?
      refute version("3.5.1").prerelease?
      assert_equal "v3.5.1", version("3.5.1").tag
    end

    should "parse only well-formed v tags" do
      assert_equal version("3.5.0"), ReleaseTools::Version.from_tag("v3.5.0")
      assert_nil ReleaseTools::Version.from_tag("3.5.0")
      assert_nil ReleaseTools::Version.from_tag("vnext")
    end
  end

  context "version source" do
    should "read and replace the VERSION constant" do
      source = %(module Drip\n  VERSION = "3.5.0"\nend\n)
      assert_equal "3.5.0", ReleaseTools.version_from_source(source)
      assert_equal %(module Drip\n  VERSION = "3.5.1"\nend\n), ReleaseTools.with_version(source, version("3.5.1"))
    end

    should "fail without a VERSION constant" do
      assert_raises(ReleaseTools::Error) { ReleaseTools.version_from_source("") }
      assert_raises(ReleaseTools::Error) { ReleaseTools.with_version("", version("3.5.1")) }
    end
  end

  should "find the latest version among tags" do
    assert_equal version("3.5.1.rc1"), ReleaseTools.latest_version(%w[v3.4.2 v3.5.1.rc1 v3.5.0 junk])
    assert_nil ReleaseTools.latest_version([])
  end

  context "metadata" do
    should "describe Drip::VERSION" do
      assert_equal({ "version" => "3.5.1.rc1", "tag" => "v3.5.1.rc1", "prerelease" => "true" },
                   ReleaseTools.metadata(%(VERSION = "3.5.1.rc1"), nil))
    end

    should "accept a matching tag and reject a mismatched one" do
      assert_equal "v3.5.1", ReleaseTools.metadata(%(VERSION = "3.5.1"), "v3.5.1")["tag"]
      assert_raises(ReleaseTools::Error) { ReleaseTools.metadata(%(VERSION = "3.5.1"), "v3.5.2") }
    end
  end

  context "changelog" do
    should "round-trip the repository CHANGELOG.md unchanged" do
      text = File.read(File.expand_path("../../CHANGELOG.md", __dir__))
      assert_equal text, ReleaseTools::Changelog.render(ReleaseTools::Changelog.parse(text))
    end

    should "parse sections" do
      unreleased, released = ReleaseTools::Changelog.parse(CHANGELOG).sections
      assert_equal ["Unreleased", nil, "### Fixed\n- A bug."], [unreleased.label, unreleased.date, unreleased.body]
      assert_equal ["3.5.0", Date.new(2026, 7, 10)], [released.label, released.date]
      assert_equal "https://github.com/DripEmail/drip-ruby/compare/v3.4.2...v3.5.0", released.link
    end

    should "reject malformed headings" do
      assert_raises(ReleaseTools::Error) { ReleaseTools::Changelog.parse("## [3.5.0] on Tuesday\n") }
    end

    should "move Unreleased entries under a dated release section" do
      assert_equal RELEASED, ReleaseTools::Changelog.release(CHANGELOG, version("3.5.1"), TODAY)
    end

    should "refuse to release an empty Unreleased section or a prerelease" do
      assert_raises(ReleaseTools::Error) { ReleaseTools::Changelog.release(EMPTY_UNRELEASED, version("3.5.1"), TODAY) }
      assert_raises(ReleaseTools::Error) { ReleaseTools::Changelog.release(CHANGELOG, version("3.5.1.rc1"), TODAY) }
    end

    should "require an Unreleased compare link against the previous tag" do
      broken = CHANGELOG.sub("compare/v3.5.0...HEAD", "compare/main")
      assert_raises(ReleaseTools::Error) { ReleaseTools::Changelog.release(broken, version("3.5.1"), TODAY) }
    end
  end

  context "notes" do
    should "render a final release section with a visible compare link" do
      expected = "### Fixed\n- A bug.\n\n**Full diff**: https://github.com/DripEmail/drip-ruby/compare/v3.5.0...v3.5.1\n"
      assert_equal expected, ReleaseTools::Changelog.notes(RELEASED, version("3.5.1"))
    end

    should "render a prerelease from Unreleased, comparing up to its tag" do
      expected = "### Fixed\n- A bug.\n\n**Full diff**: https://github.com/DripEmail/drip-ruby/compare/v3.5.0...v3.5.1.rc1\n"
      assert_equal expected, ReleaseTools::Changelog.notes(CHANGELOG, version("3.5.1.rc1"))
    end

    should "fail for a missing or empty section" do
      assert_raises(ReleaseTools::Error) { ReleaseTools::Changelog.notes(CHANGELOG, version("3.6.0")) }
      assert_raises(ReleaseTools::Error) { ReleaseTools::Changelog.notes(EMPTY_UNRELEASED, version("3.5.1.rc1")) }
    end
  end

  context "prepare_problems" do
    should "pass for a valid release branch" do
      assert_empty ReleaseTools::Checks.prepare_problems(prepare_facts)
      assert_empty ReleaseTools::Checks.prepare_problems(prepare_facts(version: "3.5.1.rc1"))
    end

    should "report every failed check" do
      problems = ReleaseTools::Checks.prepare_problems(prepare_facts(
                                                         version: "3.5.0", branch: "main", clean: false, based_on_origin_main: false, changelog: EMPTY_UNRELEASED
      ))
      assert_equal 6, problems.size, problems.inspect
    end

    should "report a malformed version" do
      assert_match(/malformed version/, ReleaseTools::Checks.prepare_problems(prepare_facts(version: "")).join)
    end
  end

  context "tag_problems" do
    should "pass for a releasable main" do
      assert_empty ReleaseTools::Checks.tag_problems(tag_facts)
    end

    should "report every failed check" do
      problems = ReleaseTools::Checks.tag_problems(tag_facts(
                                                     branch: "topic", clean: false, origin_main: "def", tags: %w[v3.5.0],
                                                     published_versions: %w[3.5.0], ci_conclusion: ""
      ))
      assert_equal 7, problems.size, problems.inspect
      assert_includes problems, "CI on HEAD is missing, not success"
    end

    should "report a release section dated after today" do
      assert_equal ["CHANGELOG.md date for 3.5.0 is after today"],
                   ReleaseTools::Checks.tag_problems(tag_facts(today: Date.new(2026, 7, 9)))
    end

    should "report a version with no CHANGELOG.md section" do
      assert_equal ["CHANGELOG.md has no section for 3.5.1"],
                   ReleaseTools::Checks.tag_problems(tag_facts(version_source: %(VERSION = "3.5.1"\n)))
    end

    should "report a malformed or missing version" do
      assert_match(/malformed version/, ReleaseTools::Checks.tag_problems(tag_facts(version_source: %(VERSION = "next"))).join)
      assert_equal ["no VERSION constant found"], ReleaseTools::Checks.tag_problems(tag_facts(version_source: ""))
    end
  end
end
