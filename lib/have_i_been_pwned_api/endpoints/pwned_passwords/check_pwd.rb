# frozen_string_literal: true

require_relative "../endpoint"
require "digest"

module HaveIBeenPwnedApi
  module PwnedPasswords
    class CheckPwd < Endpoint
      def self.type
        :free
      end

      def self.call(password:, add_padding: false)
        digest = hash_password(password)

        response = Client.get(uri(digest[..4]),
                              headers: { add_padding: add_padding })

        partial_hash = Regexp.escape(digest[5..])
        count = response.body.match(/#{partial_hash}:(\d+)/) { $1.to_i }

        count.nil? ? false : true
      end

      private

      def self.hash_password(password)
        Digest::SHA1.hexdigest(password).upcase
      end

      def self.uri(digest_chars)
        URI("#{endpoint_url}range/#{digest_chars}")
      end
    end
  end
end
