# frozen_string_literal: true

RSpec.describe HaveIBeenPwnedApi::Subscription do
  describe "Creates all necesary endpoint methods automatically" do
    let(:expected_methods) { %i[status] }

    it "is expected to respond to all expected_methods" do
      expected_methods.each do |m|
        expect(described_class.respond_to?(m)).to eq(true)
      end
    end
  end
end
