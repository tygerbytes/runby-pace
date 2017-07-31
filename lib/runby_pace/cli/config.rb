# frozen_string_literal: true

require 'yaml'
require 'pp'

module Runby
  #
  module Cli
    class Config
      USER_CONFIG_PATH = File.expand_path('~/.runbypace').freeze

      VALID_OPTIONS = {
        five_k_time: { validate_as: RunbyTime }
      }.freeze

      def initialize
        @settings = load_user_settings
      end

      def load_user_settings
        if File.exist? USER_CONFIG_PATH
          YAML.load_file USER_CONFIG_PATH
        else
          {}
        end
      end

      def store_user_settings
        File.open(USER_CONFIG_PATH, 'w') { |file| file.write @settings.to_yaml }
      end

      def [](key)
        return unless known_setting?(key)
        return unless option_configured?(key)
        "#{key} => #{@settings[key]}"
      end

      def []=(key, value)
        return unless known_setting?(key)
        if value
          value = sanitize_value key, value
          return unless value
          @settings[key] = value.to_s
        else
          @settings.delete(key)
        end
        store_user_settings
      end

      def pretty_print
        pp @settings
      end

      def known_setting?(key)
        unless VALID_OPTIONS.key?(key.to_sym)
          puts "Unknown setting #{key}"
          return false
        end
        true
      end

      def sanitize_value(key, value)
        cls = VALID_OPTIONS[key.to_sym][:validate_as]
        begin
          value = Runby.sanitize(value).as(cls)
        rescue StandardError => ex
          value = nil
          p ex.message
        end
        value
      end

      def option_configured?(key)
        unless @settings.key? key
          puts "#{key} not configured. Set with:\n\trunbypace --config #{key} VALUE"
          false
        end
        true
      end
    end
  end
end