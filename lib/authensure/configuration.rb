# frozen_string_literal: true

module Authensure
  class Configuration
    attr_accessor :api_key, :access_token, :base_url, :timeout, :retry_attempts, :retry_delay, :debug

    DEFAULT_BASE_URL = "https://api.authensure.app/api"
    DEFAULT_TIMEOUT = 30
    DEFAULT_RETRY_ATTEMPTS = 3
    DEFAULT_RETRY_DELAY = 1

    def initialize
      @api_key = ENV.fetch("AUTHENSURE_API_KEY", nil)
      @access_token = nil
      @base_url = ENV.fetch("AUTHENSURE_BASE_URL", DEFAULT_BASE_URL)
      @timeout = DEFAULT_TIMEOUT
      @retry_attempts = DEFAULT_RETRY_ATTEMPTS
      @retry_delay = DEFAULT_RETRY_DELAY
      @debug = false
    end
  end
end
