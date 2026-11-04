# frozen_string_literal: true

require "json"
require "net/http"
require "open3"
require_relative "release_tools"

module ReleaseTasks
  VERSION_FILE = "lib/drip/version.rb"
  CHANGELOG = "CHANGELOG.md"
  RUBYGEMS_VERSIONS = URI("https://rubygems.org/api/v1/versions/drip-ruby.json")

module_function

  def capture(*command)
    out, err, status = Open3.capture3(*command)
    raise ReleaseTools::Error, "#{command.join(' ')} failed: #{err.strip}" unless status.success?

    out.strip
  rescue SystemCallError => e
    raise ReleaseTools::Error, "#{command.first}: #{e.message}"
  end

  def git(*) = capture("git", *)
  def fetch = git("fetch", "--quiet", "--tags", "origin")
  def branch = git("rev-parse", "--abbrev-ref", "HEAD")
  def clean? = git("status", "--porcelain").empty?
  def tags = git("tag", "--list", "v*").lines(chomp: true)

  def published_versions
    response = Net::HTTP.get_response(RUBYGEMS_VERSIONS)
    return [] if response.is_a?(Net::HTTPNotFound)
    raise ReleaseTools::Error, "RubyGems lookup failed: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body).map { |entry| entry.fetch("number") }
  end

  def ci_conclusion(sha)
    capture("gh", "run", "list", "--workflow", "ci.yml", "--commit", sha, "--event", "push",
            "--json", "conclusion", "--jq", '.[0].conclusion // ""')
  end

  def current_version = ReleaseTools::Version.new(string: ReleaseTools.version_from_source(File.read(VERSION_FILE)))

  def abort_on(problems)
    abort(["Release checks failed:", *problems.map { |problem| "  - #{problem}" }].join("\n")) if problems.any?
  end

  def run
    yield
  rescue ReleaseTools::Error => e
    abort(e.message)
  end
end

namespace :release do
  desc "Set Drip::VERSION to VERSION and roll CHANGELOG.md, on a branch off an up-to-date main"
  task :prepare, [:version] do |_task, args|
    ReleaseTasks.run do
      ReleaseTasks.fetch
      ReleaseTasks.abort_on(ReleaseTools::Checks.prepare_problems(ReleaseTools::Checks::PrepareFacts.new(
                                                                    version: args[:version].to_s,
                                                                    branch: ReleaseTasks.branch,
                                                                    clean: ReleaseTasks.clean?,
                                                                    based_on_origin_main: system("git", "merge-base", "--is-ancestor", "origin/main", "HEAD"),
                                                                    tags: ReleaseTasks.tags,
                                                                    changelog: File.read(ReleaseTasks::CHANGELOG)
      )))

      version = ReleaseTools::Version.new(string: args[:version])
      File.write(ReleaseTasks::VERSION_FILE, ReleaseTools.with_version(File.read(ReleaseTasks::VERSION_FILE), version))
      unless version.prerelease?
        changelog = ReleaseTools::Changelog.release(File.read(ReleaseTasks::CHANGELOG), version, Date.today)
        File.write(ReleaseTasks::CHANGELOG, changelog)
      end

      sh "bundle", "exec", "rake"
      sh "git", "--no-pager", "diff", "--stat"
      puts <<~NEXT

        Prepared #{version.tag}. Next:
          git commit -am "Release #{version.tag}"
          push the branch, open a PR, and merge it after review
          then, on an up-to-date main: bundle exec rake release:tag
      NEXT
    end
  end

  desc "Check that main is releasable, then create and push the v<Drip::VERSION> tag"
  task :tag do
    ReleaseTasks.run do
      ReleaseTasks.fetch
      head = ReleaseTasks.git("rev-parse", "HEAD")
      changelog = File.read(ReleaseTasks::CHANGELOG)
      ReleaseTasks.abort_on(ReleaseTools::Checks.tag_problems(ReleaseTools::Checks::TagFacts.new(
                                                                branch: ReleaseTasks.branch,
                                                                clean: ReleaseTasks.clean?,
                                                                head:,
                                                                origin_main: ReleaseTasks.git("rev-parse", "origin/main"),
                                                                version_source: File.read(ReleaseTasks::VERSION_FILE),
                                                                tags: ReleaseTasks.tags,
                                                                published_versions: ReleaseTasks.published_versions,
                                                                changelog:,
                                                                today: Date.today,
                                                                ci_conclusion: ReleaseTasks.ci_conclusion(head)
      )))

      version = ReleaseTasks.current_version
      puts "Release notes for #{version.tag}:\n\n#{ReleaseTools::Changelog.notes(changelog, version)}"
      print "Type #{version.tag} to create and push the tag: "
      abort("Not tagged.") unless $stdin.gets.to_s.strip == version.tag

      sh "git", "tag", "-a", version.tag, "-m", version.tag
      sh "git", "push", "origin", version.tag
      puts <<~NEXT

        Pushed #{version.tag}. Watch the release:
          gh run watch "$(gh run list --workflow release.yml --event push --limit 1 --json databaseId --jq '.[0].databaseId')"
      NEXT
    end
  end

  desc "Print the release notes for VERSION (default: Drip::VERSION)"
  task :notes, [:version] do |_task, args|
    ReleaseTasks.run do
      version = args[:version] ? ReleaseTools::Version.new(string: args[:version]) : ReleaseTasks.current_version
      $stdout.write(ReleaseTools::Changelog.notes(File.read(ReleaseTasks::CHANGELOG), version))
    end
  end

  desc "Print release metadata as GitHub Actions outputs, checking TAG against Drip::VERSION when given"
  task :metadata, [:tag] do |_task, args|
    ReleaseTasks.run do
      ReleaseTools.metadata(File.read(ReleaseTasks::VERSION_FILE), args[:tag]).each { |key, value| puts "#{key}=#{value}" }
    end
  end
end
