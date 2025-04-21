# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Breaches::BreachedAccount do
  include_context "with default configuration"

  describe ".call" do
    context "given an account" do
      let(:account) { "email@mail.com" }
      let(:mock_response_body) do
        File.read("spec/fixtures/endpoints/breaches/breached_account_response.json")
      end

      let(:mock_truncated_response_body) do
        File.read("spec/fixtures/endpoints/breaches/breached_account_response_truncated.json")
      end

      context "when no extra params are given" do
        before do
          stub_request(:get, "https://haveibeenpwned.com/api/v3/breachedaccount/#{account}")
            .to_return(body: mock_truncated_response_body, headers: { "Content-Type" => "application/json" })
        end

        subject(:response) { described_class.call(account: account) }

        it "builds the uri and performs the request" do
          expect(response.body).to eq(mock_truncated_response_body)
        end
      end

      context "when extra params are given" do
        let(:params) do
          {
            domain: "domain",
            include_unverified: true,
            truncate_response: false,
            other_param: 1
          }
        end

        before do
          stub_request(:get, "https://haveibeenpwned.com/api/v3/breachedaccount/#{account}")
            .with(query: { domain: "domain", includeunverified: true, truncateresponse: false })
            .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
        end

        subject(:response) { described_class.call(account: account, **params) }

        it "builds the uri and performs the request only with allowed headers" do
          expect(response.body).to eq(mock_response_body)
        end
      end
    end
  end
end
