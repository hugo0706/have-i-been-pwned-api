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

      it "builds the uri and performs the request" do
        expect(response.body).to eq(mock_response_body)
      end
    end

    context "when params are given" do
      let(:params) { { domain: "domain", is_spam_list: true, other_param: 1 } }

      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/breaches")
          .with(query: { domain: "domain", isspamlist: true })
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call(**params) }

      it "builds the uri and performs the request only with allowed headers" do
        expect(response.body).to eq(mock_response_body)
      end
    end
  end
end
