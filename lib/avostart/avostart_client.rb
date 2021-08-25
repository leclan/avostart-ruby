# frozen_string_literal: true

module Avostart
  class AvostartClient
    attr_accessor :conn, :expires_in
    # Initializes a new AvostartClient. Expects a http.rb connection object, and
    # uses a default connection unless one is passed.
    def initialize(conn = nil)
      self.conn = conn || self.class.default_conn
    end

    def self.active_client
      Thread.current[:avostart_client] || AvostartClient.new(default_conn)
    end

    # A default HTTPrb connection to be used when one isn't configured. This
    # object should never be mutated, and instead instantiating your own
    # connection and wrapping it in a AvostartClient object should be preferred.
    def self.default_conn
      Thread.current[:avostart_client_default_conn] ||= HTTP.persistent(Avostart.api_base)
    end

    def access_token_expired?
      return true if Thread.current[:avostart_access_token].nil?
      
      Time.now > (Thread.current[:avostart_access_token][:exp] - 300)
    end

    def execute_request(method, path,
                        api_base: nil, api_key: nil, headers: {}, params: {})
      api_base ||= Avostart.api_base

      if access_token_expired?
        parsed_access_token_response = fetch_access_token.parse
        Thread.current[:avostart_access_token] = { 
          token: parsed_access_token_response['access_token'],
          exp: Time.now + parsed_access_token_response['expires_in']
        }
      end

      headers[:authorization] = "Bearer #{Thread.current[:avostart_access_token][:token]}"

      u = URI.parse(path)
      unless u.query.nil?
        query_params ||= {}
        query_params = Hash[URI.decode_www_form(u.query)].merge(query_params)

        # Reset the path minus any query parameters that were specified.
        path = u.path
      end

      url = api_url(path, api_base)
      http_resp = conn.public_send(method, url, params: params[:query], form: params[:form], json: params[:body], headers: headers)
      raise general_api_error(http_resp.status, JSON.parse(http_resp.to_s)) unless http_resp.status.success?

      resp = AvostartResponse.from_faraday_response(http_resp)
      # Allows AvostartClient#request to return a response object to a caller.
      @last_response = resp
      [resp, api_key]
    rescue JSON::ParserError
      raise general_api_error(http_resp.status, http_resp.body)
    end

    private

    def general_api_error(status, body)
      APIError.new("Invalid response object from API: #{body.inspect} " \
                   "(HTTP response code was #{status})",
                   http_status: status, http_body: body)
    end

    def api_url(url = '', api_base = nil)
      (api_base || Avostart.api_base) + url
    end

    def fetch_access_token
      url = [api_url, 'token'].join('/')
      conn.post(
        url,
        form: { 
          grant_type: 'client_credentials', 
          client_id: Avostart.client_id,
          client_secret: Avostart.client_secret
        }
      )
    end
  end
end