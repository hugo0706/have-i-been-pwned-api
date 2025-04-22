#frozen_string_literal: true

module HaveIBeenPwnedApi
  module Models
    class TruncatedBreach
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end
  end
end
