# frozen_string_literal: true

RSpec.describe HaveIBeenPwnedApi::Breaches do
  describe "Creates all necesary endpoint methods automatically" do
    let(:expected_methods) do
      %i[breach breached_account breached_domain
         breaches data_classes latest_breach
         subscribed_domains]
    end

    it "is expected to respond to all expected_methods" do
      expected_methods.each do |m|
        expect(described_class.respond_to?(m)).to eq(true)
      end
    end
  end
end
