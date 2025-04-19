module HaveIBeenPwnedApi
  module Utils
    module Strings
      def self.camelize_param(str)
        str.gsub(/_([a-z])/) { $1.upcase }
      end
    end
  end
end