# frozen_string_literal: true

require_relative "../support/shared_contexts/configuration/configuration"

RSpec.describe HaveIBeenPwnedApi::Client do
  include_context "with default configuration"

  describe ".get" do
    let(:config) { HaveIBeenPwnedApi.config }
    let(:user_agent) { config.user_agent }
    let(:uri) { URI("https://test.com") }
    let(:headers) { default_headers }
    let(:response_status) { 200 }
    let(:default_headers) do
      {
        "hibp-api-key": config.api_key,
        "user-agent": user_agent
      }
    end

    let(:response_headers) do
      {
        "content-type": "application/json"
      }
    end

    let(:body) { "{}" }

    before do
      stub_request(:get, uri)
        .with(headers: headers)
        .to_return(body: body,
                   headers: response_headers,
                   status: response_status)
    end

    context "when given just an uri" do
      subject(:response) { described_class.get(uri) }

      context "when response content type is application/json" do
        it "makes a get request with default headers and returns parsed JSON body" do
          expect(response).to eq({})
        end
      end

      context "when response content type is text/plain" do
        let(:response_headers) do
          {
            "content-type": "text/plain"
          }
        end
        it "makes a get request with default headers and returns plain text body" do
          expect(response).to eq("{}")
        end
      end

      context "when response content type is other" do
        let(:response_headers) do
          {
            "content-type": "other-type"
          }
        end
        it "makes a get request with default headers and returns plain text body" do
          expect(response).to eq("{}")
        end
      end

      context "error codes" do
        error_classes = {
          400 => HaveIBeenPwnedApi::BadRequest,
          401 => HaveIBeenPwnedApi::Unauthorized,
          403 => HaveIBeenPwnedApi::Forbidden,
          404 => HaveIBeenPwnedApi::NotFound,
          429 => HaveIBeenPwnedApi::RateLimitExceeded,
          503 => HaveIBeenPwnedApi::ServiceUnavailable
        }
        error_classes.each do |status, error_class|
          context "when the server returns #{status}" do
            let(:body) { "something went wrong" }
            let(:response_status) { status }

            it "raises #{error_class}" do
              expect { described_class.get(uri) }
                .to raise_error(error_class) { |e|
                  expect(e.detail).to eq(body)
                }
            end
          end
        end
      end
    end

    context "when given an uri and headers" do
      let!(:headers) do
        default_headers.merge({ add_padding: true, header: 123 })
      end

      subject(:response) { described_class.get(uri, headers: headers) }

      it "sends exactly the merged headers" do
        expect(response).to eq({})
      end
    end
  end
end
