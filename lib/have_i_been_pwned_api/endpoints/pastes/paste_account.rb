# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Pastes
    class PasteAccount < Endpoint
      class << self
        def call(account:)
          data = Client.get(uri(account))
          Models::PasteCollection.new(data)
        end

        private

        def uri(account)
          encoded_account = URI.encode_www_form_component(account)
          URI("#{endpoint_url}pasteaccount/#{encoded_account}")
        end
      end
    end
  end
end
