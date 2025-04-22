# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Breaches::LatestBreach do
  include_context "with default configuration"

  describe ".call" do
    let(:mock_response_body) do
      File.read("spec/fixtures/endpoints/breaches/latest_breach_response.json")
    end

    before do
      stub_request(:get, "https://haveibeenpwned.com/api/v3/latestbreach")
        .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
    end

    subject(:response) { described_class.call }

    it "returns a Breach object with the correct data" do
      expect(response).to be_a(HaveIBeenPwnedApi::Models::Breach)
      expect(response.name).to        eq("SamsungGermany")
      expect(response.domain).to      eq("samsung.de")
      expect(response.pwn_count).to   eq(216_333)
      expect(response.added_date).to  be_a(DateTime)
      expect(response.data_classes).to eq(["Email addresses", "Names", "Physical addresses",
                                           "Purchases", "Salutations", "Shipment tracking numbers",
                                           "Support tickets"])
    end
  end
end
