# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Subscription::Status do
  include_context "with default configuration"

  describe ".call" do
    let(:mock_response_body) do
      File.read("spec/fixtures/endpoints/subscription/status_response.json")
    end

    before do
      stub_request(:get, "https://haveibeenpwned.com/api/v3/subscription/status")
        .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
    end

    subject(:response) { described_class.call }

    it "builds the uri and performs the request" do
      expect(response).to be_an(HaveIBeenPwnedApi::Models::SubscriptionStatus)
      expect(response.subscription_name).to eq("Pwned 1")
      expect(response.domain_search_max_breached_accounts).to eq(25)
      expect(response.subscribed_until).to be_a(DateTime)
    end
  end
end
