# frozen_string_literal: true

module Avostart
  # AvostartError is the base error from which all other more specific Stripe
  # errors derive.
  class AvostartError < StandardError
    attr_reader :message

    # Response contains a AvostartResponse object that has some basic information
    # about the response that conveyed the error.
    attr_accessor :response

    attr_reader :code
    attr_reader :http_body
    attr_reader :http_headers
    attr_reader :http_status
    attr_reader :json_body # equivalent to #data
    attr_reader :request_id

    # Initializes a AvostartError.
    def initialize(message = nil, http_status: nil, http_body: nil,
                   json_body: nil, http_headers: nil, code: nil)
      @message = message
      @http_status = http_status
      @http_body = http_body
      @http_headers = http_headers || {}
      @json_body = json_body
      @code = code
      @request_id = @http_headers[:request_id]
    end

    def to_s
      status_string = @http_status.nil? ? '' : "(Status #{@http_status}) "
      id_string = @request_id.nil? ? '' : "(Request #{@request_id}) "
      "#{status_string}#{id_string}#{@message}"
    end
  end

  # APIError is a generic error that may be raised in cases where none of the
  # other named errors cover the problem. It could also be raised in the case
  # that a new error has been introduced in the API, but this version of the
  # Ruby SDK doesn't know how to handle it.
  class APIError < AvostartError
  end

  class NotFoundError < AvostartError
  end

  # InvalidRequestError is raised when a request is initiated with invalid
  # parameters.
  class InvalidRequestError < AvostartError
    attr_accessor :param

    def initialize(message, param, http_status: nil, http_body: nil,
                   json_body: nil, http_headers: nil, code: nil)
      super(message, http_status: http_status, http_body: http_body,
                     json_body: json_body, http_headers: http_headers,
                     code: code)
      @param = param
    end
  end
end
