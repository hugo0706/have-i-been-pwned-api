# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Breaches::SubscribedDomains do
  include_context "with default configuration"

  describe ".call" do
    let(:mock_response_body) do
      File.read("spec/fixtures/endpoints/breaches/subscribed_domains_response.json")
    end

    before do
      stub_request(:get, "https://haveibeenpwned.com/api/v3/subscribeddomains")
        .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
    end

    subject(:response) { described_class.call }

    it "builds the uri and performs the request" do
      expect(response).to be_an(Array)
      expect(response).to all(be_an(HaveIBeenPwnedApi::Models::Domain))
      expect(response.first.domain_name).to eq("domain.com")
      expect(response.first.pwn_count).to eq(20_102)
      expect(response.first.pwn_count_excluding_spam_lists).to eq(nil)
      expect(response.first.pwn_count_excluding_spam_lists_at_last_subscription_renewal).to eq(15_012)
      expect(response.first.next_subscription_renewal).to be_a(DateTime)
    end
  end
end
