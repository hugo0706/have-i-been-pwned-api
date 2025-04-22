#frozen_string_literal: true

require "date"

module HaveIBeenPwnedApi
  module Models
    class Breach
      ATTRS = %w[ Name Title Domain BreachDate AddedDate ModifiedDate
                  PwnCount Description DataClasses IsVerified
                  IsFabricated IsSensitive IsRetired IsSpamList
                  IsMalware IsSubscriptionFree IsStealerLog LogoPath].freeze

      DATE_FIELDS     = %w[BreachDate].freeze
      DATETIME_FIELDS = %w[AddedDate ModifiedDate].freeze

      ATTRS.each do |k|
        attr_reader Utils::Strings.underscore(k).to_sym
      end

      def initialize(attrs)
        ATTRS.each do |k|
          key = Utils::Strings.underscore(k)
          raw = attrs[k]
          value = parse_date_field(k, raw)
          instance_variable_set("@#{key}", value)
        end
      end

      private

      def parse_date_field(field, raw)
        case field
        when *DATE_FIELDS
          raw && Date.iso8601(raw)
        when *DATETIME_FIELDS
          raw && DateTime.parse(raw)
        else
          raw
        end
      end
    end
  end
end
