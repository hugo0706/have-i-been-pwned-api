# frozen_string_literal: true

require "net/http"
require "uri"

module HaveIBeenPwnedApi
  class Client
    class << self
      def get(uri)
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        request["hibp-api-key"] = config.api_key
        request["user-agent"] = "test"
        http.request(request).body
      end

      private

      def config
        HaveIBeenPwnedApi.config
      end
    end
  end
end
