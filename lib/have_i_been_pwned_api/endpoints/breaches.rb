# frozen_string_literal: true

require_relative "breaches/latest_breach"
require_relative "breaches/breached_account"
require_relative "breaches/breach"
require_relative "breaches/breached_domain"
require_relative "breaches/breaches"
require_relative "breaches/data_classes"
require_relative "breaches/latest_breach"
require_relative "breaches/subscribed_domains"

module HaveIBeenPwnedApi
  module Breaches
    def self.latest_breach
      puts LatestBreach.call
    end

    def self.breached_account(account:, **kwargs)
      puts BreachedAccount.call(account: account, **kwargs)
    end

    def self.breach(name:)
      puts Breach.call(name: name)
    end

    def self.breached_domain(domain:)
      puts BreachedDomain.call(domain: domain)
    end

    def self.breaches(*kwargs)
      puts Breaches.call(**kwargs)
    end

    def self.data_classes
      puts DataClasses.call
    end

    def self.subscribed_domains
      puts SubscribedDomains.call
    end
  end
end
