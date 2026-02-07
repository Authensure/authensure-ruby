# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Signatures < Base
      def list
        response = http.get("/signatures")
        response.map { |s| symbolize_keys(s) }
      end

      def get(signature_id)
        response = http.get("/signatures/#{signature_id}")
        symbolize_keys(response)
      end

      def create(name:, data:, type: "drawn", **options)
        body = { name: name, data: data, type: type }.merge(options)
        response = http.post("/signatures", body)
        symbolize_keys(response)
      end

      def update(signature_id, **attributes)
        response = http.patch("/signatures/#{signature_id}", attributes)
        symbolize_keys(response)
      end

      def delete(signature_id)
        http.delete("/signatures/#{signature_id}")
        true
      end

      def set_default(signature_id)
        response = http.post("/signatures/#{signature_id}/default")
        symbolize_keys(response)
      end
    end
  end
end
