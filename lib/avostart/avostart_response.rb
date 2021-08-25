# frozen_string_literal: true

module Avostart
  # AvostartResponse encapsulates some vitals of a response that came back from
  # the Avostart API.
  class AvostartResponse
    # The data contained by the HTTP body of the response deserialized from
    # JSON.
    attr_accessor :data

    # The raw HTTP body of the response.
    attr_accessor :http_body

    # A Hash of the HTTP headers of the response.
    attr_accessor :http_headers

    # The integer HTTP status code of the response.
    attr_accessor :http_status

    # Initializes a AvostartResponse object from a HTTPrb response object.
    #
    # This may throw JSON::ParserError if the response body is not valid JSON.
    def self.from_faraday_response(http_resp)
      resp = AvostartResponse.new
      resp.data = http_resp.body.empty? ? {} : JSON.parse(http_resp.body)
      resp.http_body = http_resp.body
      resp.http_headers = http_resp.headers
      resp.http_status = http_resp.status
      resp
    end
  end
end
