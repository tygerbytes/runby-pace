# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :build

task build: %i[gen_all_run_types spec]

desc 'Generate the all_run_types.g.rb file'
task :gen_all_run_types do
  puts "\e[32m__TEXT__\e[0m".gsub('__TEXT__', 'Generate all_run_types.g.rb')
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
