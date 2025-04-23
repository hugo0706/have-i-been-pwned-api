# frozen_string_literal: true

require "date"

module HaveIBeenPwnedApi
  module Models
    class SubscriptionStatus
      ATTRS = %w[SubscriptionName Description SubscribedUntil
                 Rpm DomainSearchMaxBreachedAccounts].freeze

      DATETIME_FIELDS = %w[SubscribedUntil].freeze

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
        when *DATETIME_FIELDS
          raw && DateTime.parse(raw)
        else
          raw
        end
      end
    end
  end
end
