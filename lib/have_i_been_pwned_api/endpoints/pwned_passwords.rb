# frozen_string_literal: true

require_relative "pwned_passwords/check_pwd"

require_relative "../../utils/strings"
require_relative "../../utils/autoloader"

module HaveIBeenPwnedApi
  module PwnedPasswords
    Utils::Autoloader.define_endpoint_methods(self)
  end
end
