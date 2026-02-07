# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Templates < Base
      def list(limit: nil, offset: nil)
        params = {}
        params[:limit] = limit if limit
        params[:offset] = offset if offset
        response = http.get("/templates", params)
        response.map { |t| symbolize_keys(t) }
      end

      def get(template_id)
        response = http.get("/templates/#{template_id}")
        symbolize_keys(response)
      end

      def create(name:, description: nil, **options)
        body = { name: name }
        body[:description] = description if description
        body.merge!(options)
        response = http.post("/templates", body)
        symbolize_keys(response)
      end

      def update(template_id, **attributes)
        response = http.patch("/templates/#{template_id}", attributes)
        symbolize_keys(response)
      end

      def delete(template_id)
        http.delete("/templates/#{template_id}")
      end

      def add_role(template_id, name:, **options)
        body = { name: name }.merge(options)
        response = http.post("/templates/#{template_id}/roles", body)
        symbolize_keys(response)
      end

      def update_role(template_id, role_id, **attributes)
        response = http.patch("/templates/#{template_id}/roles/#{role_id}", attributes)
        symbolize_keys(response)
      end

      def delete_role(template_id, role_id)
        http.delete("/templates/#{template_id}/roles/#{role_id}")
      end

      def add_document(template_id, file:, filename:, mime_type: nil)
        response = http.upload(
          "/templates/#{template_id}/documents",
          file: file,
          filename: filename,
          mime_type: mime_type || "application/pdf"
        )
        symbolize_keys(response)
      end

      def use(template_id, name:, recipients:, **options)
        body = { name: name, recipients: recipients }.merge(options)
        response = http.post("/templates/#{template_id}/use", body)
        symbolize_keys(response)
      end

      def duplicate(template_id, name: nil)
        body = {}
        body[:name] = name if name
        response = http.post("/templates/#{template_id}/duplicate", body)
        symbolize_keys(response)
      end
    end
  end
end
