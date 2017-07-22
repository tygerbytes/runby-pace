# frozen_string_literal: true

require 'readline'

module Runby
  # Command line interface and REPL for RunbyPace
  class Cli
    def initialize(args = ARGV)
      @args = args
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

    def targets(five_k_time, distance_units = :mi)
      five_k_time = Runby.sanitize(five_k_time).as(RunbyTime)
      puts "\nIf you can run a 5K in #{five_k_time}, your training paces should be:"
      RunTypes.all_classes.each do |run_type|
        run = run_type.new
        puts "  #{run.description}: #{run.lookup_pace(five_k_time, distance_units)}"
      end
      nil
    end

    # -- Shortcuts
    def d(*args)
      Distance.new(*args)
    end

    def du(*args)
      DistanceUnit.new(*args)
    end

    def p(*args)
      Pace.new(*args)
    end

    def s(*args)
      Speed.new(*args)
    end

    def t(*args)
      RunbyTime.new(*args)
    end
  end
end