#frozen_string_literal: true

module HaveIBeenPwnedApi
  module Models
    class PasteCollection
      include Enumerable

      attr_reader :pastes

      def initialize(data)
        @pastes = data.map do |h|
          Paste.new(h)
        end
      end
    end
  end
end
