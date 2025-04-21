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

      it "builds the uri and performs the request" do
        expect(response.body).to eq(mock_response_body)
      end
    end
  end
end
