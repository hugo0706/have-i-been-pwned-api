# frozen_string_literal: true

RSpec.describe HaveIBeenPwnedApi do
  it "has a version number" do
    expect(HaveIBeenPwnedApi::VERSION).not_to be nil
  end

  describe "#configure" do
    context "when no block is provided" do
      let(:configuration) { HaveIBeenPwnedApi::Configuration.new }

      before { subject.configure }

      it "should use default configuration" do
        expect(subject.configuration).to eq(configuration)
        expect(configuration.base_url).to eq(HaveIBeenPwnedApi::Configuration::FREE_URL)
        expect(configuration.api_key).to eq(nil)
        expect(configuration.free).to eq(true)
      end
    end
  end
end
