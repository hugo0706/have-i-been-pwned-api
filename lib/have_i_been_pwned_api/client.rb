# frozen_string_literal: true

require "net/http"
require "uri"

module HaveIBeenPwnedApi
  class Client
    class << self
      def get(uri, headers: {})
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        set_headers(request, headers)

        http.request(request).body
      end

      private

      def set_headers(request, headers)
        request["hibp-api-key"] = config.api_key
        request["user-agent"] = "test"

        return if headers.empty?

        headers.each do |header, value|
          header = header.to_s.gsub("_", "-")
          request[header] = value
        end
      end

      def config
        HaveIBeenPwnedApi.config
      end
    end
  end
end
