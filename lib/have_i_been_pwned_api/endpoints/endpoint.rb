# frozen_string_literal: true

require_relative "../../utils/strings"

module HaveIBeenPwnedApi
  class Endpoint
    class << self
      def type
        :premium
      end

      def endpoint_url
        config.base_url_for_endpoint_type(type)
      end

      def config
        HaveIBeenPwnedApi.config
      end

      private

      def parse_optional_params(kwargs, allowed_params)
        params = {}
        kwargs.map do |key, value|
          next unless allowed_params.include?(key)

          key = HaveIBeenPwnedApi::Utils::Strings.camelize_param(key.to_s)
          params[key] = value unless value.nil?
        end

        params
      end
    end
  end
end
