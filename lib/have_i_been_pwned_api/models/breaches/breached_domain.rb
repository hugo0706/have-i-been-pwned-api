#frozen_string_literal: true

module HaveIBeenPwnedApi
  module Models
    class BreachedDomain
      attr_reader :entries

      def initialize(attrs)
        @entries = {}
        attrs.each do |account_alias, breaches|
          @entries[account_alias] = breaches
        end
      end
    end
  end
end
