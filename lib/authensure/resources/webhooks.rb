# frozen_string_literal: true

require "openssl"
require "json"

require_relative "base"

module Authensure
  module Resources
    class Webhooks < Base
      def list
        response = http.get("/webhooks")
        webhooks = response["webhooks"] || response
        webhooks.map { |w| symbolize_keys(w) }
      end

      def get(webhook_id)
        response = http.get("/webhooks/#{webhook_id}")
        symbolize_keys(response)
      end

      def create(url:, events:, **options)
        body = { url: url, events: events }.merge(options)
        response = http.post("/webhooks", body)
        symbolize_keys(response)
      end

      def update(webhook_id, **attributes)
        response = http.patch("/webhooks/#{webhook_id}", attributes)
        symbolize_keys(response)
      end

      def delete(webhook_id)
        http.delete("/webhooks/#{webhook_id}")
      end

      def test(webhook_id)
        response = http.post("/webhooks/#{webhook_id}/test")
        symbolize_keys(response)
      end

      def list_deliveries(webhook_id, limit: nil, offset: nil)
        params = {}
        params[:limit] = limit if limit
        params[:offset] = offset if offset
        response = http.get("/webhooks/#{webhook_id}/deliveries", params)
        response.map { |d| symbolize_keys(d) }
      end

      def retry_delivery(webhook_id, delivery_id)
        response = http.post("/webhooks/#{webhook_id}/deliveries/#{delivery_id}/retry")
        symbolize_keys(response)
      end

      def self.verify_signature(payload, signature, secret)
        payload_string = payload.is_a?(String) ? payload : payload.to_json
        sig = signature.start_with?("sha256=") ? signature[7..] : signature

        expected = OpenSSL::HMAC.hexdigest("SHA256", secret, payload_string)
        secure_compare(expected, sig)
      end

      def self.construct_event(payload, signature, secret)
        payload_string = payload.is_a?(String) ? payload : payload.to_json

        unless verify_signature(payload_string, signature, secret)
          raise Authensure::Error.new("Invalid webhook signature", code: "INVALID_SIGNATURE")
        end

        parsed = payload.is_a?(String) ? JSON.parse(payload) : payload
        {
          event: parsed["event"],
          data: parsed["data"],
          timestamp: parsed["timestamp"]
        }
      end

      def self.secure_compare(a, b)
        return false if a.nil? || b.nil? || a.bytesize != b.bytesize

        l = a.unpack("C*")
        r = 0
        b.each_byte { |v| r |= v ^ l.shift }
        r.zero?
      end

      private_class_method :secure_compare
    end
  end
end
