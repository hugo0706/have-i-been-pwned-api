# frozen_string_literal: true

RSpec.describe HaveIBeenPwnedApi::PwnedPasswords do
  describe "Creates all necesary endpoint methods automatically" do
    let(:expected_methods) { %i[check_pwd] }

    it "is expected to respond to all expected_methods" do
      expected_methods.each do |m|
        expect(described_class.respond_to?(m)).to eq(true)
      end
    end
  end
end
