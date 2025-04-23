# frozen_string_literal: true

module HaveIBeenPwnedApi
  module Utils
    module Strings
      def self.underscore(str)
        str.gsub(/([a-z])([A-Z])/) { "#{$1}_#{$2.downcase}" }
           .gsub(/([A-Z][a-z])/, '_\1')
           .sub(/^_/, "").downcase
      end
    end
  end
end
