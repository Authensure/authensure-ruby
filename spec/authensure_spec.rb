# frozen_string_literal: true

RSpec.describe Authensure do
  it "has a version number" do
    expect(Authensure::VERSION).not_to be_nil
    expect(Authensure::VERSION).to eq("1.0.0")
  end

  describe ".configure" do
    it "yields configuration" do
      described_class.configure do |config|
        config.api_key = "test_api_key"
        config.base_url = "https://custom.api.com"
      end

      expect(described_class.configuration.api_key).to eq("test_api_key")
      expect(described_class.configuration.base_url).to eq("https://custom.api.com")
    end
  end

  describe ".client" do
    it "returns a new client instance" do
      client = described_class.client(api_key: "test_key")
      expect(client).to be_a(Authensure::Client)
    end
  end
end
