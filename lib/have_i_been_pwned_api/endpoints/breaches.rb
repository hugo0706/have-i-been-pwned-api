# frozen_string_literal: true

require_relative "breaches/latest_breach"
require_relative "breaches/breached_account"
require_relative "breaches/breach"
require_relative "breaches/breached_domain"
require_relative "breaches/breaches"
require_relative "breaches/data_classes"
require_relative "breaches/latest_breach"
require_relative "breaches/subscribed_domains"

require_relative "../../utils/strings"

module HaveIBeenPwnedApi
  module Breaches
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
