# frozen_string_literal: true

RSpec.describe HaveIBeenPwnedApi::Configuration do
  describe "#base_url_for_endpoint_type" do
    let(:configuration) { described_class.new }

    context "when the configuration has an api_key set" do
      before { configuration.api_key = "API_KEY" }

      context "when endpoint type is premium" do
        it "returns premium url" do
          result = configuration.base_url_for_endpoint_type(:premium)
          expect(result).to eq(described_class::PREMIUM_URL)
        end
      end

      context "when endpoint type is free" do
        it "returns free url" do
          result = configuration.base_url_for_endpoint_type(:free)
          expect(result).to eq(described_class::FREE_URL)
        end
      end
    end

    context "when the configuration does not have an api_key set" do
      context "when endpoint type is premium" do
        it "raises an error" do
          expect { configuration.base_url_for_endpoint_type(:premium) }
            .to raise_error(HaveIBeenPwnedApi::Error) { |e|
              expect(e.message).to eq("An HIBP API key is required for premium endpoints")
            }
        end
      end

      context "when endpoint type is free" do
        it "returns free url" do
          result = configuration.base_url_for_endpoint_type(:free)
          expect(result).to eq(described_class::FREE_URL)
        end
      end
    end
  end

  describe "#==" do
    context "given an equal configuration" do
      it "returns true" do
        conf = described_class.new
        expect(conf == described_class.new).to eq true
      end
    end

    context "given a different configuration" do
      it "returns false" do
        conf = described_class.new
        conf.api_key = "API_KEY"
        expect(conf == described_class.new).to eq false
      end
    end
  end

  describe "#attributes" do
    it "returns and array of attribute name and value pairs" do
      conf = described_class.new
      expect(conf.attributes).to eq([[:@api_key, nil]])
    end
  end
end
