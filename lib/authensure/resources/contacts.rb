# frozen_string_literal: true

require_relative "base"

module Authensure
  module Resources
    class Contacts < Base
      def list(search: nil, limit: nil, offset: nil)
        params = {}
        params[:search] = search if search
        params[:limit] = limit if limit
        params[:offset] = offset if offset
        response = http.get("/contacts", params)
        response.map { |c| symbolize_keys(c) }
      end

      def get(contact_id)
        response = http.get("/contacts/#{contact_id}")
        symbolize_keys(response)
      end

      def create(email:, name:, company: nil, **options)
        body = { email: email, name: name }
        body[:company] = company if company
        body.merge!(options)
        response = http.post("/contacts", body)
        symbolize_keys(response)
      end

      def update(contact_id, **attributes)
        response = http.patch("/contacts/#{contact_id}", attributes)
        symbolize_keys(response)
      end

      def delete(contact_id)
        http.delete("/contacts/#{contact_id}")
      end

      def stats
        response = http.get("/contacts/stats")
        symbolize_keys(response)
      end
    end
  end
end
