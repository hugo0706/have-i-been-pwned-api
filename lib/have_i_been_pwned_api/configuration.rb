# frozen_string_literal: true

module HaveIBeenPwnedApi
  class Configuration
    PREMIUM_URL = "https://haveibeenpwned.com/api/v3/"
    FREE_URL = "https://api.pwnedpasswords.com/range/"

    attr_accessor :api_key, :free
    attr_reader :base_url

    def initialize
      @api_key = nil
      @free = true
      @base_url = select_base_url
    end

    def ==(other)
      other.is_a?(Configuration) &&
        attributes == other.attributes
    end

    def attributes
      instance_variables.map { |iv| [iv, instance_variable_get(iv)] }
    end

    private

    def select_base_url
      free ? FREE_URL : PREMIUM_URL
    end
  end
end
