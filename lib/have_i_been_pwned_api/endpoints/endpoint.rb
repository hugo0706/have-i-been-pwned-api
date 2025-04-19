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
    end
  end
end
