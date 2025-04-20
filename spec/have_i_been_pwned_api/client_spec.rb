# frozen_string_literal: true

require_relative "../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Client do
  include_context "with default configuration"

  describe ".get" do
    let(:config) { HaveIBeenPwnedApi.config }
    let(:user_agent) { config.user_agent }

    context "when given just an uri" do
      let(:uri) { URI("https://test.com") }

      before do
        stub_request(:get, /test.com/)
          .with(headers: { "hibp-api-key": config.api_key,
                           "user-agent": user_agent })
      end

      it "makes a get request to uri with default headers" do
        response = described_class.get(uri)

        expect(response.code).to eq "200"
      end
    end

    context "when given an uri and headers" do
      let(:uri) { URI("https://test.com") }
      let(:headers) do
        {
          add_padding: true,
          header: 123
        }
      end

      before do
        stub_request(:get, /test.com/)
          .with(headers: { "hibp-api-key": config.api_key,
                           "user-agent": user_agent,
                           "add-padding": true,
                           "header": 123 })
      end

      it "makes a get request to uri with default headers" do
        response = described_class.get(uri, headers: headers)

        expect(response.code).to eq "200"
      end
    end
  end
end
