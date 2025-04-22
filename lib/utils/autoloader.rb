# frozen_string_literal: true

module HaveIBeenPwnedApi
  module Utils
    module Autoloader
      def self.define_endpoint_methods(mod)
        mod.constants.each do |c|
          klass = mod.const_get(c)
          next unless klass.is_a?(Class)
          raise Error unless klass.respond_to?(:call)

          method_name = HaveIBeenPwnedApi::Utils::Strings.underscore(c.to_s)
          mod.define_singleton_method(method_name.to_sym) do |**kwargs|
            klass.call(**kwargs)
          end
        end
      end
    end
  end
end
