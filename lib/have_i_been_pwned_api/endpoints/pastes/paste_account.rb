# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Pastes
    class PasteAccount < Endpoint
      class << self
        def call(account:)
          Client.get(uri(account))
        end

        private

        def uri(account)
          URI("#{endpoint_url}pasteaccount/#{account}")
        end
      end
    end
  end
end
