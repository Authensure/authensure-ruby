# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Envelopes < Base
      def list(status: nil, limit: nil, offset: nil)
        params = {}
        params[:status] = status if status
        params[:limit] = limit if limit
        params[:offset] = offset if offset
        response = http.get("/envelopes", params)
        response.map { |e| symbolize_keys(e) }
      end

      def get(envelope_id)
        response = http.get("/envelopes/#{envelope_id}")
        symbolize_keys(response)
      end

      def create(name:, message: nil, **options)
        body = { name: name }
        body[:message] = message if message
        body.merge!(options)
        response = http.post("/envelopes", body)
        symbolize_keys(response)
      end

      def update(envelope_id, **attributes)
        response = http.patch("/envelopes/#{envelope_id}", attributes)
        symbolize_keys(response)
      end

      def delete(envelope_id)
        http.delete("/envelopes/#{envelope_id}")
      end

      def add_recipient(envelope_id, email:, name:, role: "signer", **options)
        body = { email: email, name: name, role: role }.merge(options)
        response = http.post("/envelopes/#{envelope_id}/recipients", body)
        symbolize_keys(response)
      end

      def remove_recipient(envelope_id, recipient_id)
        http.delete("/envelopes/#{envelope_id}/recipients/#{recipient_id}")
      end

      def send_envelope(envelope_id)
        response = http.post("/envelopes/#{envelope_id}/send")
        symbolize_keys(response)
      end

      def void(envelope_id, reason: nil)
        body = {}
        body[:reason] = reason if reason
        response = http.post("/envelopes/#{envelope_id}/void", body)
        symbolize_keys(response)
      end

      def get_by_signing_token(token)
        response = http.get("/envelopes/sign/#{token}")
        symbolize_keys(response)
      end

      def download(envelope_id, format: "pdf")
        http.get("/envelopes/#{envelope_id}/download", { format: format })
      end

      def get_audit_trail(envelope_id)
        response = http.get("/envelopes/#{envelope_id}/audit")
        symbolize_keys(response)
      end
    end
  end
end
