# frozen_string_literal: true

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

          key = key.to_s.gsub("_", "")
          params[key] = value unless value.nil?
        end

        params
      end
    end
  end
end
