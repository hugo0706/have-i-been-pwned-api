# frozen_string_literal: true

module HaveIBeenPwnedApi
  class Error < StandardError
    attr_reader :detail
    DEFAULT_MESSAGE = "An unexpected error occurred"

    # @param message [String] custom error message
    # @param detail  [String, nil] raw response body or other debug info
    def initialize(message: nil, detail: nil)
      super(message || self.class::DEFAULT_MESSAGE)
      @detail = detail
    end

    def to_s
      if detail && !detail.empty?
        "#{super} - Error detail: #{detail}"
      else
        super
      end
    end
  end

  class BadRequest < Error
    DEFAULT_MESSAGE = "Bad request — invalid resource format"
  end

  class Unauthorized < Error
    DEFAULT_MESSAGE = "Missing or invalid API key"
  end

  class Forbidden < Error
    DEFAULT_MESSAGE = "Forbidden — Check error details"
  end

  class NotFound < Error
    DEFAULT_MESSAGE = "Resource Not found"
  end

  class RateLimitExceeded < Error
    DEFAULT_MESSAGE = "Rate limit exceeded"
  end

  class ServiceUnavailable < Error
    DEFAULT_MESSAGE = "Service unavailable"
  end
end
