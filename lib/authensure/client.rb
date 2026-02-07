# frozen_string_literal: true

module Authensure
  class Client
    attr_reader :config, :http

    def initialize(options = {})
      @config = build_config(options)
      @http = HttpClient.new(@config)
    end

    def auth
      @auth ||= Resources::Auth.new(@http)
    end

    def envelopes
      @envelopes ||= Resources::Envelopes.new(@http)
    end

    def documents
      @documents ||= Resources::Documents.new(@http)
    end

    def templates
      @templates ||= Resources::Templates.new(@http)
    end

    def contacts
      @contacts ||= Resources::Contacts.new(@http)
    end

    def webhooks
      @webhooks ||= Resources::Webhooks.new(@http)
    end

    def users
      @users ||= Resources::Users.new(@http)
    end

    def organizations
      @organizations ||= Resources::Organizations.new(@http)
    end

    def api_keys
      @api_keys ||= Resources::ApiKeys.new(@http)
    end

    def teams
      @teams ||= Resources::Teams.new(@http)
    end

    def signatures
      @signatures ||= Resources::Signatures.new(@http)
    end

    def self.with_api_key(api_key, **options)
      new(options.merge(api_key: api_key))
    end

    def self.with_access_token(access_token, **options)
      new(options.merge(access_token: access_token))
    end

    private

    def build_config(options)
      config = Configuration.new
      config.api_key = options[:api_key] if options[:api_key]
      config.access_token = options[:access_token] if options[:access_token]
      config.base_url = options[:base_url] if options[:base_url]
      config.timeout = options[:timeout] if options[:timeout]
      config.retry_attempts = options[:retry_attempts] if options[:retry_attempts]
      config.retry_delay = options[:retry_delay] if options[:retry_delay]
      config.debug = options[:debug] if options.key?(:debug)
      config
    end
  end
end
