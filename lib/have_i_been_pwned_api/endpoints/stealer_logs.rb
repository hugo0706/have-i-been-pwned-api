# frozen_string_literal: true

require_relative "stealer_logs/by_email"
require_relative "stealer_logs/by_email_domain"
require_relative "stealer_logs/by_website_domain"

require_relative "../../utils/strings"
require_relative "../../utils/autoloader"

module HaveIBeenPwnedApi
  module StealerLogs
    Utils::Autoloader.define_endpoint_methods(self)
  end
end
