# frozen_string_literal: true

require_relative "subscription/status"

require_relative "../../utils/strings"
require_relative "../../utils/autoloader"

module HaveIBeenPwnedApi
  module Subscription
    HaveIBeenPwnedApi::Utils::Autoloader.define_endpoint_methods(self)
  end
end
