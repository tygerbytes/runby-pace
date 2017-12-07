# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require_relative 'lib/runby_pace/utility/warning_suppressant'

RSpec::Core::RakeTask.new(:spec)

task default: :build

task build: %i[gen_version_number gen_all_run_types spec]

desc 'Generate the all_run_types.g.rb file'
task :gen_all_run_types do
  puts "\e[32m__TEXT__\e[0m".gsub('__TEXT__', '> Generate all_run_types.g.rb')
  run_types_path = './lib/runby_pace/run_types'

  # Parse *_run.rb file names to generate array of the run type class names
  run_type_files = Dir.entries(run_types_path).select { |file| /.*_run\.rb/ =~ file }

  all_run_types = run_type_files.map do |filename|
    filename_sans_extension = filename[0, filename.length - 3]
    parts = filename_sans_extension.to_s.downcase.split(/_|\./)
    run_type = ''
    parts.each do |part|
      run_type += part[0].upcase + part[-(part.length - 1), part.length - 1]
    end
    run_type
  end
  puts all_run_types.join(' ')

  # Write run types to the generated file, all_run_types.g.rb
  template = File.read(File.join(run_types_path, 'all_run_types.template'))
  template.gsub!('__RUN_TYPE_NAMES__', all_run_types.join(' '))
  template.gsub!('__RUN_TYPES__', all_run_types.join(', '))
  File.write(File.join(run_types_path, 'all_run_types.g.rb'), template)
  puts "\e[32mDone\e[0m\n\n"
end

desc 'Generate version number'
task :gen_version_number do
  puts "\e[32m__TEXT__\e[0m".gsub('__TEXT__', '> Generate version number')

  # Generate "teeny" version number based on the number of commits since the last tagged major/minor release
  latest_tagged_release = `git describe --tags --abbrev=0 --match v*`.to_s.chomp
  puts "\e[32m__TEXT__\e[0m".gsub('__TEXT__', "Latest tagged release is #{latest_tagged_release}")
  version = "#{latest_tagged_release[1..-1]}.#{`git rev-list --count #{latest_tagged_release}..HEAD`}".chomp

  # Write version number to generated file
  path = './lib/runby_pace'
  template = File.read(File.join(path, 'version.seed'))
  template.gsub!('__VERSION__', version)
  version_file_path = File.join(path, 'version.g.rb')
  File.write(version_file_path, template)
  Runby.with_no_warnings do
    # Silencing warnings about redefining constants, since it's intentional
    load version_file_path
    Runby::VERSION = Runby::GENERATED_VERSION
  end
  puts "\e[32m__TEXT__\e[0m".gsub('__TEXT__', "Version: #{Runby::VERSION}")
end
