# frozen_string_literal: true

RSpec.shared_context "with default configuration" do
  before do
    HaveIBeenPwnedApi.configure do |config|
      config.api_key = "API_KEY"
    end
  end
end
