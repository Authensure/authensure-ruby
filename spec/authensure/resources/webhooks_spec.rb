# frozen_string_literal: true

RSpec.describe Authensure::Resources::Webhooks do
  let(:client) { Authensure::Client.new(api_key: "test_api_key") }
  let(:webhooks) { client.webhooks }

  describe "#list" do
    it "returns list of webhooks" do
      stub_authensure_request(:get, "/webhooks", response_body: {
        webhooks: [{ id: "whk_123", url: "https://example.com/webhook" }]
      })

      result = webhooks.list
      expect(result).to be_an(Array)
      expect(result.first[:id]).to eq("whk_123")
    end
  end

  describe "#create" do
    it "creates a webhook" do
      stub_authensure_request(:post, "/webhooks", response_body: {
        id: "whk_new", url: "https://example.com/webhook", events: ["envelope.signed"]
      }, status: 201)

      result = webhooks.create(url: "https://example.com/webhook", events: ["envelope.signed"])
      expect(result[:id]).to eq("whk_new")
    end
  end

  describe ".verify_signature" do
    let(:payload) { '{"event":"envelope.signed","data":{}}' }
    let(:secret) { "whsec_test_secret" }

    it "returns true for valid signature" do
      expected_sig = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      signature = "sha256=#{expected_sig}"

      expect(described_class.verify_signature(payload, signature, secret)).to be true
    end

    it "returns false for invalid signature" do
      expect(described_class.verify_signature(payload, "sha256=invalid", secret)).to be false
    end

    it "handles signature without prefix" do
      expected_sig = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      expect(described_class.verify_signature(payload, expected_sig, secret)).to be true
    end
  end

  describe ".construct_event" do
    let(:payload) { '{"event":"envelope.signed","data":{"envelopeId":"env_123"},"timestamp":"2024-01-01T00:00:00Z"}' }
    let(:secret) { "whsec_test_secret" }

    it "returns event hash for valid signature" do
      expected_sig = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      signature = "sha256=#{expected_sig}"

      event = described_class.construct_event(payload, signature, secret)
      expect(event[:event]).to eq("envelope.signed")
      expect(event[:data]["envelopeId"]).to eq("env_123")
    end

    it "raises error for invalid signature" do
      expect do
        described_class.construct_event(payload, "sha256=invalid", secret)
      end.to raise_error(Authensure::Error, /Invalid webhook signature/)
    end
  end
end
