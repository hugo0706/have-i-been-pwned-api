# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Breaches::Breaches do
  include_context "with default configuration"

  describe ".call" do
    let(:mock_response_body) do
      File.read("spec/fixtures/endpoints/breaches/breaches_response.json")
    end

    context "when no params are given" do
      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/breaches")
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call }

      it "returns a collection of breaches" do
        expect(response).to be_an(HaveIBeenPwnedApi::Models::BreachCollection)
        expect(response.breaches).to all(be_a(HaveIBeenPwnedApi::Models::Breach))
        expect(response.breaches.length).to eq(882)
        expect(response.breaches.first.name).to          eq("000webhost")
        expect(response.breaches.first.domain).to        eq("000webhost.com")
        expect(response.breaches.first.pwn_count).to     eq(14_936_670)
        expect(response.breaches.first.added_date).to    be_a(DateTime)
        expect(response.breaches.first.data_classes).to  eq(["Email addresses", "IP addresses",
                                                             "Names", "Passwords"])
      end
    end

    context "when params are given" do
      let(:params) { { domain: "domain", is_spam_list: true } }

      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/breaches")
          .with(query: { domain: "domain", isspamlist: true })
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call(**params) }

      it "performs the request only with allowed headers and returns a collection of breaches" do
        expect(response).to be_an(HaveIBeenPwnedApi::Models::BreachCollection)
        expect(response.breaches).to all(be_a(HaveIBeenPwnedApi::Models::Breach))
        expect(response.breaches.length).to eq(882)
        expect(response.breaches.first.name).to          eq("000webhost")
        expect(response.breaches.first.domain).to        eq("000webhost.com")
        expect(response.breaches.first.pwn_count).to     eq(14_936_670)
        expect(response.breaches.first.added_date).to    be_a(DateTime)
        expect(response.breaches.first.data_classes).to  eq(["Email addresses", "IP addresses",
                                                             "Names", "Passwords"])
      end
    end
  end
end
