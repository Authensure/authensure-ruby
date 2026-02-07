# frozen_string_literal: true

RSpec.describe Authensure::Resources::Envelopes do
  let(:client) { Authensure::Client.new(api_key: "test_api_key") }
  let(:envelopes) { client.envelopes }

  describe "#list" do
    it "returns list of envelopes" do
      stub_authensure_request(:get, "/envelopes", response_body: [
        { id: "env_123", name: "Test Envelope", status: "DRAFT" }
      ])

      result = envelopes.list
      expect(result).to be_an(Array)
      expect(result.first[:id]).to eq("env_123")
    end

    it "accepts status filter" do
      stub_request(:get, "https://api.authensure.app/api/envelopes")
        .with(query: { status: "DRAFT" })
        .to_return(status: 200, body: [].to_json, headers: { "Content-Type" => "application/json" })

      envelopes.list(status: "DRAFT")
    end
  end

  describe "#get" do
    it "returns single envelope" do
      stub_authensure_request(:get, "/envelopes/env_123", response_body: {
        id: "env_123", name: "Test Envelope", status: "DRAFT"
      })

      result = envelopes.get("env_123")
      expect(result[:id]).to eq("env_123")
      expect(result[:name]).to eq("Test Envelope")
    end
  end

  describe "#create" do
    it "creates an envelope" do
      stub_authensure_request(:post, "/envelopes", response_body: {
        id: "env_new", name: "New Envelope", status: "DRAFT"
      }, status: 201)

      result = envelopes.create(name: "New Envelope", message: "Please sign")
      expect(result[:id]).to eq("env_new")
    end
  end

  describe "#update" do
    it "updates an envelope" do
      stub_authensure_request(:patch, "/envelopes/env_123", response_body: {
        id: "env_123", name: "Updated Envelope"
      })

      result = envelopes.update("env_123", name: "Updated Envelope")
      expect(result[:name]).to eq("Updated Envelope")
    end
  end

  describe "#delete" do
    it "deletes an envelope" do
      stub_authensure_request(:delete, "/envelopes/env_123", response_body: { success: true })

      result = envelopes.delete("env_123")
      expect(result).to be_truthy
    end
  end

  describe "#add_recipient" do
    it "adds a recipient to envelope" do
      stub_authensure_request(:post, "/envelopes/env_123/recipients", response_body: {
        id: "rec_456", email: "signer@example.com", name: "John Doe"
      }, status: 201)

      result = envelopes.add_recipient("env_123", email: "signer@example.com", name: "John Doe")
      expect(result[:id]).to eq("rec_456")
      expect(result[:email]).to eq("signer@example.com")
    end
  end

  describe "#send_envelope" do
    it "sends an envelope" do
      stub_authensure_request(:post, "/envelopes/env_123/send", response_body: {
        id: "env_123", status: "SENT", sentAt: "2024-01-01T12:00:00Z"
      })

      result = envelopes.send_envelope("env_123")
      expect(result[:status]).to eq("SENT")
    end
  end

  describe "#void" do
    it "voids an envelope" do
      stub_authensure_request(:post, "/envelopes/env_123/void", response_body: {
        id: "env_123", status: "VOIDED", voidReason: "Cancelled"
      })

      result = envelopes.void("env_123", reason: "Cancelled")
      expect(result[:status]).to eq("VOIDED")
    end
  end
end
