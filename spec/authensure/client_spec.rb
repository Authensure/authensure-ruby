# frozen_string_literal: true

RSpec.describe Authensure::Client do
  let(:api_key) { "test_api_key_123" }
  let(:client) { described_class.new(api_key: api_key) }

  describe "#initialize" do
    it "creates a client with api_key" do
      expect(client.config.api_key).to eq(api_key)
    end

    it "creates a client with access_token" do
      token_client = described_class.new(access_token: "test_token")
      expect(token_client.config.access_token).to eq("test_token")
    end

    it "uses default base_url" do
      expect(client.config.base_url).to eq("https://api.authensure.app/api")
    end

    it "allows custom base_url" do
      custom_client = described_class.new(api_key: api_key, base_url: "https://custom.api.com")
      expect(custom_client.config.base_url).to eq("https://custom.api.com")
    end
  end

  describe ".with_api_key" do
    it "creates a client with api_key" do
      client = described_class.with_api_key("my_key")
      expect(client.config.api_key).to eq("my_key")
    end
  end

  describe ".with_access_token" do
    it "creates a client with access_token" do
      client = described_class.with_access_token("my_token")
      expect(client.config.access_token).to eq("my_token")
    end
  end

  describe "resource accessors" do
    it "returns auth resource" do
      expect(client.auth).to be_a(Authensure::Resources::Auth)
    end

    it "returns envelopes resource" do
      expect(client.envelopes).to be_a(Authensure::Resources::Envelopes)
    end

    it "returns documents resource" do
      expect(client.documents).to be_a(Authensure::Resources::Documents)
    end

    it "returns templates resource" do
      expect(client.templates).to be_a(Authensure::Resources::Templates)
    end

    it "returns contacts resource" do
      expect(client.contacts).to be_a(Authensure::Resources::Contacts)
    end

    it "returns webhooks resource" do
      expect(client.webhooks).to be_a(Authensure::Resources::Webhooks)
    end

    it "returns users resource" do
      expect(client.users).to be_a(Authensure::Resources::Users)
    end

    it "returns organizations resource" do
      expect(client.organizations).to be_a(Authensure::Resources::Organizations)
    end

    it "returns api_keys resource" do
      expect(client.api_keys).to be_a(Authensure::Resources::ApiKeys)
    end

    it "returns teams resource" do
      expect(client.teams).to be_a(Authensure::Resources::Teams)
    end

    it "returns signatures resource" do
      expect(client.signatures).to be_a(Authensure::Resources::Signatures)
    end
  end
end
