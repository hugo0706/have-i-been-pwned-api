# frozen_string_literal: true

require_relative "stealer_logs/by_email"
require_relative "stealer_logs/by_email_domain"
require_relative "stealer_logs/by_website_domain"

require_relative "../../utils/strings"

module HaveIBeenPwnedApi
  module StealerLogs
    constants.each do |c|
      klass = const_get(c)
      next unless klass.is_a?(Class)
      raise Error unless klass.respond_to?(:call)
      method_name = HaveIBeenPwnedApi::Utils::Strings.class_to_camel_case(c.to_s)
      define_singleton_method(method_name.to_sym) do |**kwargs|
        puts klass.call(**kwargs)
      end
    end
  end
end
