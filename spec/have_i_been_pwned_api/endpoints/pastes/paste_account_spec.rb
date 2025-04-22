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

      it "returns a PasteCollection object" do
        expect(response).to be_a(HaveIBeenPwnedApi::Models::PasteCollection)
        expect(response.pastes).to all(be_a(HaveIBeenPwnedApi::Models::Paste))
        expect(response.pastes.first.source).to eq("Pastebin")
        expect(response.pastes.first.id).to eq("8Q0BvKD8")
        expect(response.pastes.first.title).to eq("syslog")
        expect(response.pastes.first.date).to be_a(DateTime)
        expect(response.pastes.first.email_count).to eq(139)
      end
    end
  end
end
