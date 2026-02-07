# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Organizations < Base
      def get
        response = http.get("/organizations")
        symbolize_keys(response)
      end

      def update(**attributes)
        response = http.patch("/organizations", attributes)
        symbolize_keys(response)
      end

      def upload_logo(file:, filename:, mime_type: nil)
        response = http.upload(
          "/organizations/logo",
          file: file,
          filename: filename,
          mime_type: mime_type || "image/png"
        )
        symbolize_keys(response)
      end

      def delete_logo
        http.delete("/organizations/logo")
        true
      end

      def get_settings
        response = http.get("/organizations/settings")
        symbolize_keys(response)
      end

      def update_settings(**settings)
        response = http.patch("/organizations/settings", settings)
        symbolize_keys(response)
      end

      def get_branding
        response = http.get("/organizations/branding")
        symbolize_keys(response)
      end

      def update_branding(**branding)
        response = http.patch("/organizations/branding", branding)
        symbolize_keys(response)
      end
    end
  end
end
