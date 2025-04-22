# frozen_string_literal: true

require_relative "../../../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::PwnedPasswords::CheckPwd do
  include_context "with default configuration"

  describe ".type" do
    it "returns free type" do
      expect(described_class.type).to eq(:free)
    end
  end

  describe ".call" do
    let(:pwd) { "password" }
    # Pre-calculated using SHA1
    let(:sha1_hashed_pwd) { "5BAA61E4C9B93F3F0682250B6CF8331B7EE68FD8" }

    let(:add_padding) { false }
    let(:sha_1_mock_response_body) do
      File.read("spec/fixtures/endpoints/pwned_passwords/check_pwd_sha_1_response.txt")
    end

    before do
      stub_request(:get, "https://api.pwnedpasswords.com/range/#{sha1_hashed_pwd[..4]}")
        .with(headers: { 'add-padding': add_padding })
        .to_return(body: response_body, headers: { "content-type": "text/plain" })
    end

    context "when given just a password" do
      let(:response_body) { sha_1_mock_response_body }
      subject(:response) { described_class.call(password: pwd) }

      context "when the password has been compromised" do
        it "returns true" do
          expect(response).to eq(true)
        end
      end

      context "when the password has not been compromised" do
        let(:sha1_hashed_pwd) { "RANDOMHASH" }

        before do
          allow(described_class).to receive(:hash_password)
            .with(pwd).and_return(sha1_hashed_pwd)
        end

        it "returns false" do
          expect(response).to eq(false)
        end
      end
    end

    context "when given a password and add_padding set to true" do
      let(:response_body) { sha_1_mock_response_body }
      let(:add_padding) { true }
      subject(:response) { described_class.call(password: pwd, add_padding: true) }

      context "when the password has been compromised" do
        it "returns true" do
          expect(response).to eq(true)
        end
      end
    end
  end
end
