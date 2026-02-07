# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Documents < Base
      def upload(envelope_id:, file:, filename:, mime_type: nil)
        response = http.upload(
          "/envelopes/#{envelope_id}/documents",
          file: file,
          filename: filename,
          mime_type: mime_type || "application/pdf"
        )
        symbolize_keys(response)
      end

      def get(document_id)
        response = http.get("/documents/#{document_id}")
        symbolize_keys(response)
      end

      def download(document_id)
        http.get("/documents/#{document_id}/download")
      end

      def delete(document_id)
        http.delete("/documents/#{document_id}")
      end

      def get_signed_url(document_id)
        response = http.get("/documents/#{document_id}/signed-url")
        symbolize_keys(response)
      end

      def add_field(document_id, field_type:, page:, x:, y:, width:, height:, recipient_id: nil, **options)
        body = {
          fieldType: field_type,
          page: page,
          x: x,
          y: y,
          width: width,
          height: height
        }
        body[:recipientId] = recipient_id if recipient_id
        body.merge!(options)
        response = http.post("/documents/#{document_id}/fields", body)
        symbolize_keys(response)
      end

      def update_field(document_id, field_id, **attributes)
        response = http.patch("/documents/#{document_id}/fields/#{field_id}", attributes)
        symbolize_keys(response)
      end

      def delete_field(document_id, field_id)
        http.delete("/documents/#{document_id}/fields/#{field_id}")
      end

      def list_fields(document_id)
        response = http.get("/documents/#{document_id}/fields")
        response.map { |f| symbolize_keys(f) }
      end
    end
  end
end
