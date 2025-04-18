# frozen_string_literal: true

module HaveIBeenPwnedApi
  class Configuration
    PREMIUM_URL = "https://haveibeenpwned.com/api/v3/"
    FREE_URL = "https://api.pwnedpasswords.com/range/"

    attr_accessor :api_key

    def initialize
      @api_key = nil
    end

    def base_url_for_endpoint_type(type)
      check_access_allowed!(type)
      type == :free ? FREE_URL : PREMIUM_URL
    end

    def ==(other)
      other.is_a?(Configuration) &&
        attributes == other.attributes
    end

    def attributes
      instance_variables.map { |iv| [iv, instance_variable_get(iv)] }
    end

    private

    def check_access_allowed!(type)
      return unless api_key.nil? && type == :premium

      raise HaveIBeenPwnedApi::Error, "An HIBP API key is required for premium endpoints"
    end
  end
end
