# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::StealerLogs::ByWebsiteDomain do
  include_context "with default configuration"

  describe ".call" do
    context "given a domain" do
      let(:domain) { "domain.com" }
      let(:mock_response_body) do
        File.read("spec/fixtures/endpoints/stealer_logs/by_email_domain_response.json")
      end

      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/stealerlogsbywebsitedomain/#{domain}")
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call(domain: domain) }

      it "builds the uri and performs the request" do
        expect(response).to eq(JSON.parse(mock_response_body))
      end
    end
  end
end
