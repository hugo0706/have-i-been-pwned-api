# frozen_string_literal: true

require_relative "breaches/latest_breach"
require_relative "breaches/breached_account"
require_relative "breaches/breach"
require_relative "breaches/breached_domain"
require_relative "breaches/breaches"
require_relative "breaches/data_classes"
require_relative "breaches/subscribed_domains"

require_relative "../../utils/strings"
require_relative "../../utils/autoloader"

module HaveIBeenPwnedApi
  module Breaches
    Utils::Autoloader.define_endpoint_methods(self)
  end
end
