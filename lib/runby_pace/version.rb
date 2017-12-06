# frozen_string_literal: true

require 'fileutils'
include FileUtils

module Runby

  VERSION = begin
              path = './lib/runby_pace/version.g.rb'
              if File.exist? path
                load path
                Runby::GENERATED_VERSION
              else
                puts "\e[31m__TEXT__\e[0m".gsub('__TEXT__', 'Version number not set. Run "rake gen_version_number"')
                '0.0.0'
              end
            end
end
