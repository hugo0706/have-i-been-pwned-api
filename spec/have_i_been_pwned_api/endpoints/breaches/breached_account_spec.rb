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

        it "returns a collection of TruncatedBreaches" do
          expect(response).to be_an(HaveIBeenPwnedApi::Models::BreachCollection)
          expect(response.breaches).to all(be_a(HaveIBeenPwnedApi::Models::TruncatedBreach))
          expect(response.breaches.length).to eq(3)
          expect(response.breaches.first.name).to eq("Adobe")
        end
      end

      context "when extra params are given" do
        context "when truncate_response is set to false" do
          let(:params) do
            {
              domain: "domain",
              include_unverified: true,
              truncate_response: false
            }
          end

          before do
            stub_request(:get, "https://haveibeenpwned.com/api/v3/breachedaccount/#{account}")
              .with(query: { domain: "domain", includeunverified: true, truncateresponse: false })
              .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
          end

          subject(:response) { described_class.call(account: account, **params) }

          it "performs the request only with allowed headers and returns a collection of breaches" do
            expect(response).to be_an(HaveIBeenPwnedApi::Models::BreachCollection)
            expect(response.breaches).to all(be_a(HaveIBeenPwnedApi::Models::Breach))
            expect(response.breaches.length).to eq(2)
            expect(response.breaches.first.name).to eq("Adobe")
            expect(response.breaches.first.domain).to        eq("adobe.com")
            expect(response.breaches.first.pwn_count).to     eq(152_445_165)
            expect(response.breaches.first.added_date).to    be_a(DateTime)
            expect(response.breaches.first.data_classes).to  eq(["Email addresses", "Password hints",
                                                                 "Passwords", "Usernames"])
          end
        end
      end
    end
  end
end
