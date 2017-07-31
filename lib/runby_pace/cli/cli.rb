# frozen_string_literal: true

require 'readline'
require 'optparse'
require_relative 'config'

module Runby
  module Cli
    # Command line interface and REPL for RunbyPace
    class Cli
      def initialize(args = ARGV)
        @args = args
        @config = Config.new
        @options = parse_options args
      end

      def run
        puts 'Runby Pace REPL!'
        bnd = binding
        while (input = Readline.readline('🏃 ', true))
          begin
            result = bnd.eval input
          rescue StandardError => e
            puts "#{e.class}: #{e.message}"
          else
            puts result
          end
        end
      end

      def print_targets(five_k_time, distance_units = :mi)
        five_k_time = @config['five_k_time'] if five_k_time.nil?

        five_k_time = Runby.sanitize(five_k_time).as(RunbyTime)
        puts "\nIf you can run a 5K in #{five_k_time}, your training paces should be:"
        paces = []
        RunTypes.all_classes.each do |run_type|
          run = run_type.new
          paces.push(description: run.description, pace: run.lookup_pace(five_k_time, distance_units))
        end
        paces.sort_by { |p| p[:pace].fast }.reverse_each { |p| puts "  #{p[:description]}: #{p[:pace]}" }
        nil
      end

      # -- Shortcuts for the REPL
      def di(*args)
        Distance.new(*args)
      end

      def du(*args)
        DistanceUnit.new(*args)
      end

      def pc(*args)
        Pace.new(*args)
      end

      def sp(*args)
        Speed.new(*args)
      end

      def tm(*args)
        RunbyTime.new(*args)
      end

      private

      def parse_options(options)
        args = { targets: nil }

        OptionParser.new do |opts|
          opts.banner = 'Usage: runbypace.rb [options]'

          opts.on('-h', '--help', 'Display this help message') do
            puts opts
            exit
          end

          opts.on('-c', '--config [SETTING][=NEW_VALUE]', 'Get or set a configuration value') do |config|
            manage_config config
            exit
          end

          opts.on('-t', '--targets [5K race time]', 'Show target paces') do |targets|
            args[:targets] = targets
            print_targets targets
            exit
          end
        end.parse!(options)
        args
      end

      def manage_config(config)
        c = parse_config_setting config
        unless c.key
          # No key specified. Print all settings.
          @config.pretty_print
          return
        end
        if c.value
          # Set setting "key" to new "value"
          @config[c.key] = c.value
          return
        end
        if c.clear_setting
          @config[c.key] = nil
        else
          # Print the value of setting "key"
          p @config[c.key]
        end
      end

      def parse_config_setting(setting)
        setting = '' if setting.nil?
        Class.new do
          attr_reader :key, :value, :clear_setting
          def initialize(setting)
            tokens = setting.split('=')
            @key = tokens[0]
            @value = tokens[1]
            @clear_setting = (@value.nil? && setting.include?('='))
          end
        end.new(setting)
      end
    end
  end
end
