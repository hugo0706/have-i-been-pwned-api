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

        http.request(request)
      end

      private

      def set_headers(request, headers)
        request["hibp-api-key"] = config.api_key
        request["user-agent"] = config.user_agent

        return if headers.empty?

        headers.each do |header, value|
          header = header.to_s.gsub("_", "-")
          request[header] = value.to_s
        end
      end

      def config
        HaveIBeenPwnedApi.config
      end
    end
  end
end
