# frozen_string_literal: true

require_relative "../../support/shared_contexts/configuration/configuration"

require "have_i_been_pwned_api/endpoints/endpoint"

RSpec.describe HaveIBeenPwnedApi::Endpoint do
  include_context "with default configuration"

  describe ".type" do
    it "returns default type premium" do
      expect(described_class.type).to eq(:premium)
    end
  end

  describe ".endpoint_url" do
    let(:config) { HaveIBeenPwnedApi.config }
    it "calls config's base_url_for_endpoint_type with endpoint type" do
      expect(config).to receive(:base_url_for_endpoint_type)
        .with(:premium)

      described_class.endpoint_url
    end
  end

  describe ".parse_optional_params" do
    context "when given allowed params" do
      let(:base_kwargs) { { allowed: "param", param_allowed: "param" } }
      let(:allowed_params) { %i[allowed param_allowed] }

      it "camelizes param keys and returns all params" do
        expect(described_class.send(:parse_optional_params, base_kwargs, allowed_params))
          .to eq({ "allowed" => "param", "paramAllowed" => "param" })
      end

      context "when given also non allowed params" do
        let(:kwargs) { base_kwargs.merge({ param_not_allowed: "param" }) }

        it "camelizes param keys and returns only allowed params" do
          expect(described_class.send(:parse_optional_params, kwargs, allowed_params))
            .to eq({ "allowed" => "param", "paramAllowed" => "param" })
        end
      end
    end
  end
end
