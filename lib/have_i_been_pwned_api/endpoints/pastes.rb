# frozen_string_literal: true

require_relative "pastes/paste_account"

require_relative "../../utils/strings"
require_relative "../../utils/autoloader"

module HaveIBeenPwnedApi
  module Pastes
    Utils::Autoloader.define_endpoint_methods(self)
  end
end
