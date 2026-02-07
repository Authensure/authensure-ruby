# frozen_string_literal: true

RSpec.describe Authensure::Error do
  describe "#initialize" do
    it "creates error with message" do
      error = described_class.new("Test error")
      expect(error.message).to eq("Test error")
    end

    it "creates error with all attributes" do
      error = described_class.new("Test error", code: "TEST", status_code: 400, details: { field: "value" })
      expect(error.code).to eq("TEST")
      expect(error.status_code).to eq(400)
      expect(error.details).to eq({ field: "value" })
    end
  end

  describe ".from_response" do
    it "creates AuthenticationError for 401" do
      error = described_class.from_response({ "message" => "Invalid API key" }, 401)
      expect(error).to be_a(Authensure::AuthenticationError)
      expect(error.message).to eq("Invalid API key")
    end

    it "creates NotFoundError for 404" do
      error = described_class.from_response({ "message" => "Not found" }, 404)
      expect(error).to be_a(Authensure::NotFoundError)
    end

    it "creates RateLimitError for 429" do
      error = described_class.from_response({ "message" => "Rate limited" }, 429)
      expect(error).to be_a(Authensure::RateLimitError)
    end

    it "creates ValidationError for 422" do
      error = described_class.from_response({ "message" => "Validation failed" }, 422)
      expect(error).to be_a(Authensure::ValidationError)
    end

    it "creates ServerError for 500" do
      error = described_class.from_response({ "message" => "Server error" }, 500)
      expect(error).to be_a(Authensure::ServerError)
    end
  end

  describe "#to_s" do
    it "returns formatted string" do
      error = described_class.new("Test error", code: "TEST_CODE")
      expect(error.to_s).to eq("Error(TEST_CODE): Test error")
    end
  end
end

RSpec.describe Authensure::AuthenticationError do
  it "has default message" do
    error = described_class.new
    expect(error.message).to eq("Authentication failed")
    expect(error.status_code).to eq(401)
  end
end

RSpec.describe Authensure::RateLimitError do
  it "stores retry_after" do
    error = described_class.new(retry_after: 60)
    expect(error.retry_after).to eq(60)
  end
end

RSpec.describe Authensure::ValidationError do
  it "stores validation_errors" do
    errors = { email: ["Invalid format"] }
    error = described_class.new(validation_errors: errors)
    expect(error.validation_errors).to eq(errors)
  end
end
