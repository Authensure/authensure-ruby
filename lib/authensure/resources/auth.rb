# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Auth < Base
      def login(email, password)
        response = http.post("/auth/login", { email: email, password: password })
        http.config.access_token = response["accessToken"] if response["accessToken"]
        symbolize_keys(response)
      end

      def register(email:, password:, name:, **options)
        body = { email: email, password: password, name: name }.merge(options)
        response = http.post("/auth/register", body)
        symbolize_keys(response)
      end

      def refresh_token(refresh_token)
        response = http.post("/auth/refresh", { refreshToken: refresh_token })
        http.config.access_token = response["accessToken"] if response["accessToken"]
        symbolize_keys(response)
      end

      def logout
        http.post("/auth/logout")
        http.config.access_token = nil
        true
      end

      def me
        response = http.get("/auth/me")
        symbolize_keys(response)
      end

      def verify_mfa(code:, method: nil)
        body = { code: code }
        body[:method] = method if method
        response = http.post("/auth/mfa/verify", body)
        symbolize_keys(response)
      end

      def request_password_reset(email)
        http.post("/auth/password/reset-request", { email: email })
        true
      end

      def reset_password(token:, password:)
        http.post("/auth/password/reset", { token: token, password: password })
        true
      end
    end
  end
end
