# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "faraday/retry"
require "json"

module Authensure
  class HttpClient
    attr_reader :config

    def initialize(config)
      @config = config
      @connection = build_connection
    end

    def get(path, params = {})
      request(:get, path, params: params)
    end

    def post(path, body = nil)
      request(:post, path, body: body)
    end

    def patch(path, body = nil)
      request(:patch, path, body: body)
    end

    def put(path, body = nil)
      request(:put, path, body: body)
    end

    def delete(path, params = {})
      request(:delete, path, params: params)
    end

    def upload(path, file:, filename:, mime_type: nil, additional_params: {})
      mime_type ||= "application/octet-stream"
      
      payload = additional_params.merge(
        file: Faraday::Multipart::FilePart.new(
          file.is_a?(String) ? StringIO.new(file) : file,
          mime_type,
          filename
        )
      )

      response = @connection.post(path) do |req|
        req.headers["Content-Type"] = "multipart/form-data"
        req.body = payload
      end

      handle_response(response)
    end

    private

    def build_connection
      Faraday.new(url: config.base_url) do |conn|
        conn.request :multipart
        conn.request :retry, {
          max: config.retry_attempts,
          interval: config.retry_delay,
          interval_randomness: 0.5,
          backoff_factor: 2,
          retry_statuses: [429, 500, 502, 503, 504],
          retry_if: ->(env, _exception) { retriable_request?(env) }
        }

        conn.headers["Accept"] = "application/json"
        conn.headers["User-Agent"] = "authensure-ruby/#{VERSION}"

        if config.api_key
          conn.headers["X-API-Key"] = config.api_key
        elsif config.access_token
          conn.headers["Authorization"] = "Bearer #{config.access_token}"
        end

        conn.options.timeout = config.timeout
        conn.options.open_timeout = config.timeout

        conn.response :logger if config.debug
        conn.adapter Faraday.default_adapter
      end
    end

    def request(method, path, params: nil, body: nil)
      log_request(method, path, body) if config.debug

      response = @connection.send(method, path) do |req|
        req.params = params if params && !params.empty?
        if body
          req.headers["Content-Type"] = "application/json"
          req.body = body.to_json
        end
      end

      handle_response(response)
    rescue Faraday::TimeoutError
      raise TimeoutError
    rescue Faraday::ConnectionFailed => e
      raise NetworkError, e.message
    end

    def handle_response(response)
      log_response(response) if config.debug

      body = parse_response_body(response)

      return body if response.success?

      raise Error.from_response(body.is_a?(Hash) ? body : { "message" => body.to_s }, response.status)
    end

    def parse_response_body(response)
      return {} if response.body.nil? || response.body.empty?

      content_type = response.headers["content-type"] || ""
      
      if content_type.include?("application/json")
        JSON.parse(response.body)
      elsif content_type.include?("application/pdf") || content_type.include?("application/octet-stream")
        response.body
      else
        response.body
      end
    rescue JSON::ParserError
      response.body
    end

    def retriable_request?(env)
      %i[get head options].include?(env.method)
    end

    def log_request(method, path, body)
      puts "[Authensure] #{method.upcase} #{path}"
      puts "[Authensure] Body: #{body.inspect}" if body
    end

    def log_response(response)
      puts "[Authensure] Response #{response.status}"
    end

    def set_access_token(token)
      config.access_token = token
      @connection = build_connection
    end
  end
end
