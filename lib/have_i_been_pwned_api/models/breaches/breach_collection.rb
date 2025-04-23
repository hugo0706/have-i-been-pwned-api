# frozen_string_literal: true

module HaveIBeenPwnedApi
  module Models
    class BreachCollection
      include Enumerable

      attr_reader :breaches

      def initialize(data, truncated: true)
        @breaches = data.map do |h|
          if truncated
            TruncatedBreach.new(h["Name"])
          else
            Breach.new(h)
          end
        end
      end
    end
  end
end
