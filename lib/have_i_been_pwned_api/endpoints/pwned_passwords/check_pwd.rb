# frozen_string_literal: true

require_relative "../endpoint"
require "digest"

module HaveIBeenPwnedApi
  module PwnedPasswords
    class CheckPwd < Endpoint
      ALLOWED_PARAMS = %i[mode]

      def self.type
        :free
      end

      def self.call(password:, add_padding: false, **kwargs)
        ntlm_mode = kwargs["mode"]&.downcase == "ntlm"
        digest = calculate_digest(password, ntlm_mode)

        params = parse_optional_params(kwargs, ALLOWED_PARAMS)
        response = Client.get(uri(digest[..4], params),
                              headers: { add_padding: add_padding })

        matches = response.split("\r\n").select do |val|
          val.split(":").first == digest[5..]
        end

        matches.empty? ? false : true
      end

      private

      def self.calculate_digest(password, ntlm_mode)
        if ntlm_mode
          utf16le = password.encode("UTF-16LE")
          Digest::MD4.digest(utf16le).unpack1("H*").upcase
        else
          Digest::SHA1.hexdigest(password).upcase
        end
      end

      def self.uri(digest_chars, params)
        uri = URI("#{endpoint_url}range/#{digest_chars}")
        uri.query = URI.encode_www_form(params) unless params.empty?
        uri
      end
    end
  end
end
