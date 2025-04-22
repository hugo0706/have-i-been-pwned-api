# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module HaveIBeenPwnedApi
  class Client
    ERROR_CLASSES = {
      "400" => BadRequest,
      "401" => Unauthorized,
      "403" => Forbidden,
      "404" => NotFound,
      "429" => RateLimitExceeded,
      "503" => ServiceUnavailable
    }.freeze

    class << self
      def get(uri, headers: {})
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        set_headers(request, headers)

        response = http.request(request)

        handle_errors!(response)

        parse_body(response)
      end

      private

      def handle_errors!(resp)
        return if resp.code == "200"

        error_class = ERROR_CLASSES.fetch(resp.code, Error)

        raise error_class.new(detail: resp.body)
      end

      def parse_body(resp)
        case resp.header["content-type"]
        when "text/plain"
          resp.body
        when "application/json"
          JSON.parse(resp.body) if resp.code == "200"
        else
          resp.body
        end
      end

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
