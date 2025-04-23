# frozen_string_literal: true

require_relative "../endpoint"
require "digest"

module HaveIBeenPwnedApi
  module PwnedPasswords
    class CheckPwd < Endpoint
      class << self
        def type
          :free
        end

        def call(password:, add_padding: false)
          digest = hash_password(password)

          data = Client.get(uri(digest[..4]),
                            headers: { add_padding: add_padding })

          count_password_appereances(digest, data)
        end

        private

        def count_password_appereances(digest, data)
          partial_hash = Regexp.escape(digest[5..])
          count = data.match(/#{partial_hash}:(\d+)/) { $1.to_i }
          count.nil? ? 0 : count
        end

        def hash_password(password)
          Digest::SHA1.hexdigest(password).upcase
        end

        def uri(digest_chars)
          URI("#{endpoint_url}range/#{digest_chars}")
        end
      end
    end
  end
end
