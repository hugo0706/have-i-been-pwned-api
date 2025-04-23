# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class Breach < Endpoint
      class << self
        def call(name:)
          data = Client.get(uri(name))
          Models::Breach.new(data)
        rescue NotFound
          Models::Breach.new({})
        end

        private

        def uri(name)
          encoded_name = URI.encode_www_form_component(name)
          URI("#{endpoint_url}breach/#{encoded_name}")
        end
      end
    end
  end
end
