# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Pastes::PasteAccount do
  include_context "with default configuration"

  describe ".call" do
    context "given an account" do
      let(:account) { "email@mail.com" }
      let(:mock_response_body) do
        File.read("spec/fixtures/endpoints/pastes/paste_account_response.json")
      end

      before do
        stub_request(:get, "https://haveibeenpwned.com/api/v3/pasteaccount/#{account}")
          .to_return(body: mock_response_body, headers: { "Content-Type" => "application/json" })
      end

      subject(:response) { described_class.call(account: account) }

      it "builds the uri and performs the request" do
        expect(response.body).to eq(mock_response_body)
      end
    end
  end
end
