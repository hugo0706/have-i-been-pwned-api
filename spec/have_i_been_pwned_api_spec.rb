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
        expect(configuration.api_key).to eq(nil)
      end
    end

    context "when a block is given" do
      before do
        subject.configure(&block)
      end

      let(:block) do
        lambda do |config|
          config.api_key = "API_KEY"
        end
      end

      it "uses that configuration" do
        expect(subject.config.api_key).to eq("API_KEY")
      end
    end
  end
end
