require "bundler/gem_tasks"
require "json"

task default: :test

desc "Run tests"
task :test do
  ruby("test/run-test.rb", "--use-color=yes")
end

desc "Generate gemfiles to test this plugin with released Embulk versions (since MIN_VER)"
task :gemfiles do
  min_ver = Gem::Version.new(ENV["MIN_VER"] || "0.6.12")
  puts "Generate Embulk gemfiles from #{min_ver} to latest"

  embulk_tags = JSON.parse(open("https://api.github.com/repos/embulk/embulk/tags").read)
  embulk_versons = embulk_tags.map{|tag| Gem::Version.new(tag["name"][/v(.*)/, 1])}
  latest_ver = embulk_versons.max

  root_dir = Pathname.new(File.expand_path("../", __FILE__))
  gemfiles_dir = root_dir.join("gemfiles")
  Dir[gemfiles_dir.join("embulk-*")].each{|f| File.unlink(f)}
  erb_gemfile = ERB.new(gemfiles_dir.join("template.erb").read)

  embulk_versons.sort.each do |version|
    next if version < min_ver
    File.open(gemfiles_dir.join("embulk-#{version}"), "w") do |f|
      f.puts erb_gemfile.result(binding())
    end
  end
  File.open(gemfiles_dir.join("embulk-latest"), "w") do |f|
    version = "> #{min_ver}"
    f.puts erb_gemfile.result(binding())
  end
  puts "Updated Gemfiles #{min_ver} to #{latest_ver}"

  versions = Pathname.glob(gemfiles_dir.join("embulk-*")).map(&:basename)
  erb_travis = ERB.new(root_dir.join(".travis.yml.erb").read, nil, "-")
  File.open(root_dir.join(".travis.yml"), "w") do |f|
    f.puts erb_travis.result(binding())
  end
  puts "Updated .travis.yml"
end

namespace :release do
  desc "Add header of now version release to ChangeLog and bump up version"
  task :prepare do
    root_dir = Pathname.new(File.expand_path("../", __FILE__))
    changelog_file = root_dir.join("CHANGELOG.md")
    gemspec_file = root_dir.join("embulk-input-sfdc.gemspec")

    system("git fetch origin")

    # detect merged PR
    old_version = gemspec_file.read[/spec\.version += *"([0-9]+\.[0-9]+\.[0-9]+)"/, 1]
    pr_numbers = `git log v#{old_version}..origin/master --oneline`.scan(/#[0-9]+/)

    if !$?.success? || pr_numbers.empty?
      puts "Detecting PR failed. Please confirm if any PR were merged after the latest release."
      exit(false)
    end

    # Generate new version
    major, minor, patch = old_version.split(".").map(&:to_i)
    new_version = "#{major}.#{minor}.#{patch + 1}"

    # Update ChangeLog
    pr_descriptions = pr_numbers.map do |number|
      body = open("https://api.github.com/repos/treasure-data/embulk-input-sfdc/issues/#{number.gsub("#", "")}").read
      payload = JSON.parse(body)
      "* [] #{payload["title"]} [#{number}](https://github.com/treasure-data/embulk-input-sfdc/pull/#{number.gsub('#', '')})"
    end.join("\n")

    new_changelog = <<-HEADER
## #{new_version} - #{Time.now.strftime("%Y-%m-%d")}
#{pr_descriptions}

#{changelog_file.read.chomp}
HEADER

    File.open(changelog_file, "w") {|f| f.write(new_changelog) }

    # Update version.rb
    old_content = gemspec_file.read
    File.open(gemspec_file, "w") do |f|
      f.write old_content.gsub(/(spec\.version += *)".*?"/, %Q!\\1"#{new_version}"!)
    end

    # Update Gemfile.lock
    system("bundle install")

    puts "ChangeLog, version and Gemfile.lock were updated. New version is #{new_version}."
  end
end
