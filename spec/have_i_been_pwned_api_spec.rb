# frozen_string_literal: true

RSpec.describe HaveIBeenPwnedApi do
  it "has a version number" do
    expect(HaveIBeenPwnedApi::VERSION).not_to be nil
  end

  describe "#configure" do
    before { described_class.config = nil }

    context "when no block is given" do
      let(:configuration) { HaveIBeenPwnedApi::Configuration.new }

      before { subject.configure }

      it "should use default configuration" do
        expect(subject.config).to eq(configuration)
        expect(configuration.base_url).to eq(HaveIBeenPwnedApi::Configuration::FREE_URL)
        expect(configuration.api_key).to eq(nil)
        expect(configuration.free).to eq(true)
      end
    end

    context "when a block is given" do
      context "when using a valid configuration" do
        before do
          subject.configure(&block)
        end

        let(:block) do
          lambda do |config|
            config.api_key = "API_KEY"
            config.free = false
          end
        end

        it "uses that configuration" do
          expect(subject.config.base_url).to eq(HaveIBeenPwnedApi::Configuration::PREMIUM_URL)
          expect(subject.config.api_key).to eq("API_KEY")
          expect(subject.config.free).to eq(false)
        end
      end

      context "when using a non valid configuration" do
        it "raises an error" do
          expect { subject.configure { |config| config.free = false } }
            .to raise_error(HaveIBeenPwnedApi::Error)
        end
      end
    end
  end
end
