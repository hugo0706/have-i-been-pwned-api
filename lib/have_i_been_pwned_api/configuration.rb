# frozen_string_literal: true

module HaveIBeenPwnedApi
  class Configuration
    PREMIUM_URL = "https://haveibeenpwned.com/api/v3/"
    FREE_URL = "https://api.pwnedpasswords.com/range/"

    attr_accessor :api_key, :free

    def initialize
      @api_key = nil
      @free = true
    end

    def base_url
      free ? FREE_URL : PREMIUM_URL
    end

    def ==(other)
      other.is_a?(Configuration) &&
        attributes == other.attributes
    end

    def attributes
      instance_variables.map { |iv| [iv, instance_variable_get(iv)] }
    end

    def validate!
      require_key_error = "A HIBP API key is required for non free use"
      raise HaveIBeenPwnedApi::Error, require_key_error if api_key.nil? && !free
    end
  end
end
