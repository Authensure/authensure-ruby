# frozen_string_literal: true

require_relative "authensure/version"
require_relative "authensure/configuration"
require_relative "authensure/errors"
require_relative "authensure/http_client"
require_relative "authensure/client"
require_relative "authensure/resources/auth"
require_relative "authensure/resources/envelopes"
require_relative "authensure/resources/documents"
require_relative "authensure/resources/templates"
require_relative "authensure/resources/contacts"
require_relative "authensure/resources/webhooks"
require_relative "authensure/resources/users"
require_relative "authensure/resources/organizations"
require_relative "authensure/resources/api_keys"
require_relative "authensure/resources/teams"
require_relative "authensure/resources/signatures"

module Authensure
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def client(options = {})
      Client.new(options)
    end
  end
end
