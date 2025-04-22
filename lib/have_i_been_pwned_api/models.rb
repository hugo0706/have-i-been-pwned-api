# frozen_string_literal: true

module HaveIBeenPwnedApi
  module Models
    autoload :Breach, "have_i_been_pwned_api/models/breaches/breach"
    autoload :TruncatedBreach, "have_i_been_pwned_api/models/breaches/truncated_breach"
    autoload :BreachedDomain, "have_i_been_pwned_api/models/breaches/breached_domain"
    autoload :BreachCollection, "have_i_been_pwned_api/models/breaches/breach_collection"
    autoload :Domain, "have_i_been_pwned_api/models/breaches/domain"
    autoload :Paste, "have_i_been_pwned_api/models/pastes/paste"
    autoload :PasteCollection, "have_i_been_pwned_api/models/pastes/paste_collection"
    autoload :SubscriptionStatus, "have_i_been_pwned_api/models/subscription/subscription_status"
  end
end
