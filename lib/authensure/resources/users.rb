# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Users < Base
      def get_profile
        response = http.get("/users/profile")
        symbolize_keys(response)
      end

      def update_profile(**attributes)
        response = http.patch("/users/profile", attributes)
        symbolize_keys(response)
      end

      def change_password(current_password:, new_password:)
        http.post("/users/password", {
          currentPassword: current_password,
          newPassword: new_password
        })
        true
      end

      def upload_avatar(file:, filename:, mime_type: nil)
        response = http.upload(
          "/users/avatar",
          file: file,
          filename: filename,
          mime_type: mime_type || "image/png"
        )
        symbolize_keys(response)
      end

      def delete_avatar
        http.delete("/users/avatar")
        true
      end

      def list_sessions
        response = http.get("/users/sessions")
        response.map { |s| symbolize_keys(s) }
      end

      def revoke_session(session_id)
        http.delete("/users/sessions/#{session_id}")
        true
      end

      def revoke_all_sessions
        http.delete("/users/sessions")
        true
      end

      def list_signatures
        response = http.get("/users/signatures")
        response.map { |s| symbolize_keys(s) }
      end

      def create_signature(name:, data:, **options)
        body = { name: name, data: data }.merge(options)
        response = http.post("/users/signatures", body)
        symbolize_keys(response)
      end

      def delete_signature(signature_id)
        http.delete("/users/signatures/#{signature_id}")
        true
      end

      def set_default_signature(signature_id)
        response = http.post("/users/signatures/#{signature_id}/default")
        symbolize_keys(response)
      end
    end
  end
end
