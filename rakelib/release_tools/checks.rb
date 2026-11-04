# frozen_string_literal: true

module ReleaseTools
  module Checks
    PrepareFacts = Data.define(:version, :branch, :clean, :based_on_origin_main, :tags, :changelog)
    TagFacts = Data.define(:branch, :clean, :head, :origin_main, :version_source, :tags,
                           :published_versions, :changelog, :today, :ci_conclusion)

  module_function

    def failures(*checks) = checks.filter_map { |failed, message| message if failed }

    def prepare_problems(facts)
      failures(
        [facts.branch == "main", "run on a release branch, not main"],
        [!facts.clean, "working tree is not clean"],
        [!facts.based_on_origin_main, "branch does not contain origin/main; rebase onto an up-to-date main"]
      ) + version_problems(facts.version, facts.tags) + unreleased_problems(facts.changelog)
    end

    def tag_problems(facts)
      string = ReleaseTools.version_from_source(facts.version_source)
      repository_problems(facts) + version_problems(string, facts.tags) + publication_problems(facts, string)
    rescue Error => e
      [e.message]
    end

    def repository_problems(facts)
      failures(
        [facts.branch != "main", "run on main, not #{facts.branch}"],
        [!facts.clean, "working tree is not clean"],
        [facts.head != facts.origin_main, "HEAD is not origin/main; pull first"]
      )
    end

    def publication_problems(facts, string)
      ci = facts.ci_conclusion.to_s.empty? ? "missing" : facts.ci_conclusion
      failures(
        [facts.published_versions.include?(string), "drip-ruby #{string} is already on RubyGems"],
        [ci != "success", "CI on HEAD is #{ci}, not success"]
      ) + (Version.valid?(string) ? changelog_problems(facts.changelog, Version.new(string:), facts.today) : [])
    end

    def version_problems(string, tags)
      version = Version.new(string:)
      latest = ReleaseTools.latest_version(tags)
      failures(
        [latest && version <= latest, "#{version} is not greater than the latest tag #{latest&.tag}"],
        [tags.include?(version.tag), "tag #{version.tag} already exists"]
      )
    rescue Error => e
      [e.message]
    end

    def unreleased_problems(text)
      document = Changelog.parse(text)
      Changelog.previous_tag(document)
      Changelog.nonempty(Changelog.unreleased(document))
      []
    rescue Error => e
      [e.message]
    end

    def changelog_problems(text, version, today)
      Changelog.notes(text, version)
      date = Changelog.find(Changelog.parse(text), version.to_s)&.date
      failures([date && date > today, "CHANGELOG.md date for #{version} is after today"])
    rescue Error => e
      [e.message]
    end
  end
end
