# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Breaches::Breach do
  include_context "with default configuration"

  describe ".call" do
    context "when given a name" do
      let(:mock_response_body) do
        File.read("spec/fixtures/endpoints/breaches/breach_response.json")
      end

      let(:name) { "Adobe" }

      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/breach/#{name}")
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call(name: name) }

      it "returns a Breach object with the correct data" do
        expect(response).to be_a(HaveIBeenPwnedApi::Models::Breach)
        expect(response.name).to        eq("Adobe")
        expect(response.domain).to      eq("adobe.com")
        expect(response.pwn_count).to   eq(152_445_165)
        expect(response.added_date).to  be_a(DateTime)
        expect(response.data_classes).to eq(["Email addresses", "Password hints",
                                             "Passwords", "Usernames"])
      end
    end
  end
end
