# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Breaches::BreachedDomain do
  include_context "with default configuration"

  describe ".call" do
    context "when given a domain" do
      let(:mock_response_body) do
        File.read("spec/fixtures/endpoints/breaches/breached_domain_response.json")
      end

      let(:domain) { "example.com" }

      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/breacheddomain/#{domain}")
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call(domain: domain) }

      it "returns a BreachedDomain object" do
        expect(response).to be_an(HaveIBeenPwnedApi::Models::BreachedDomain)
        expect(response.entries.length).to eq(3)
        expect(response.entries["alias2"][1]).to eq("Gawker")
      end
    end
  end
end
