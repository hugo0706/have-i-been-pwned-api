# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module HaveIBeenPwnedApi
  class Client
    class << self
      def get(uri, headers: {})
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        set_headers(request, headers)

        response = http.request(request)

        case response.header["content-type"]
        when "text/plain"
          response.body
        when "application/json"
          JSON.parse(response.body) if response.code == "200" && !response.body.empty?
        else
          JSON.parse(response.body)
        end
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
