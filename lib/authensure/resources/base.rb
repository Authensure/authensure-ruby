# frozen_string_literal: true

module Authensure
  module Resources
    class Base
      attr_reader :http

      def initialize(http)
        @http = http
      end

      private

      def symbolize_keys(hash)
        return hash unless hash.is_a?(Hash)

        hash.transform_keys(&:to_sym).transform_values do |v|
          case v
          when Hash then symbolize_keys(v)
          when Array then v.map { |item| item.is_a?(Hash) ? symbolize_keys(item) : item }
          else v
          end
        end
      end
    end
  end
end
