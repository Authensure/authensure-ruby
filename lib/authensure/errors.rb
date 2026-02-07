# frozen_string_literal: true

module Authensure
  class Error < StandardError
    attr_reader :message, :code, :status_code, :details

    def initialize(message = nil, code: nil, status_code: nil, details: nil)
      @message = message || "An error occurred"
      @code = code
      @status_code = status_code
      @details = details || {}
      super(@message)
    end

    def self.from_response(response_body, status_code)
      message = response_body["message"] || response_body["error"] || "Request failed"
      code = response_body["code"] || status_code_to_code(status_code)
      details = response_body.reject { |k, _| %w[message error code].include?(k) }

      error_class = case status_code
                    when 401 then AuthenticationError
                    when 403 then ForbiddenError
                    when 404 then NotFoundError
                    when 422 then ValidationError
                    when 429 then RateLimitError
                    when 500..599 then ServerError
                    else Error
                    end

      error_class.new(message, code: code, status_code: status_code, details: details)
    end

    def self.status_code_to_code(status_code)
      case status_code
      when 400 then "BAD_REQUEST"
      when 401 then "UNAUTHORIZED"
      when 403 then "FORBIDDEN"
      when 404 then "NOT_FOUND"
      when 422 then "VALIDATION_ERROR"
      when 429 then "RATE_LIMITED"
      when 500..599 then "SERVER_ERROR"
      else "UNKNOWN_ERROR"
      end
    end

    def to_s
      "#{self.class.name.split("::").last}(#{code}): #{message}"
    end
  end

  class AuthenticationError < Error
    def initialize(message = "Authentication failed", **options)
      super(message, code: "AUTHENTICATION_ERROR", status_code: 401, **options)
    end
  end

  class ForbiddenError < Error
    def initialize(message = "Access forbidden", **options)
      super(message, code: "FORBIDDEN", status_code: 403, **options)
    end
  end

  class NotFoundError < Error
    def initialize(resource = "Resource", **options)
      super("#{resource} not found", code: "NOT_FOUND", status_code: 404, **options)
    end
  end

  class ValidationError < Error
    attr_reader :validation_errors

    def initialize(message = "Validation failed", validation_errors: nil, **options)
      @validation_errors = validation_errors || {}
      super(message, code: "VALIDATION_ERROR", status_code: 422, **options)
    end
  end

  class RateLimitError < Error
    attr_reader :retry_after

    def initialize(message = "Rate limit exceeded", retry_after: nil, **options)
      @retry_after = retry_after
      super(message, code: "RATE_LIMITED", status_code: 429, **options)
    end
  end

  class ServerError < Error
    def initialize(message = "Server error", **options)
      super(message, code: "SERVER_ERROR", status_code: 500, **options)
    end
  end

  class NetworkError < Error
    def initialize(message = "Network error", **options)
      super(message, code: "NETWORK_ERROR", status_code: 0, **options)
    end
  end

  class TimeoutError < Error
    def initialize(message = "Request timed out", **options)
      super(message, code: "TIMEOUT", status_code: 0, **options)
    end
  end
end
