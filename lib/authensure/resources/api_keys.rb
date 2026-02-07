# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class ApiKeys < Base
      def list
        response = http.get("/api-keys")
        response.map { |k| symbolize_keys(k) }
      end

      def get(api_key_id)
        response = http.get("/api-keys/#{api_key_id}")
        symbolize_keys(response)
      end

      def create(name:, scopes: nil, expires_at: nil)
        body = { name: name }
        body[:scopes] = scopes if scopes
        body[:expiresAt] = expires_at if expires_at
        response = http.post("/api-keys", body)
        symbolize_keys(response)
      end

      def delete(api_key_id)
        http.delete("/api-keys/#{api_key_id}")
        true
      end

      def regenerate(api_key_id)
        response = http.post("/api-keys/#{api_key_id}/regenerate")
        symbolize_keys(response)
      end

      def stats(api_key_id)
        response = http.get("/api-keys/#{api_key_id}/stats")
        symbolize_keys(response)
      end
    end
  end
end
