# frozen_string_literal: true

module Avostart
  module APIOperations
    module Request
      module ClassMethods
        def request(method, url, params = {}, opts = {})

          opts[:client] ||= AvostartClient.active_client

          headers = opts.clone
          api_key = headers.delete(:api_key)
          api_base = headers.delete(:api_base)
          client = headers.delete(:client)
          # Assume all remaining opts must be headers

          resp, opts[:api_key] = client.execute_request(
            method, url,
            api_base: api_base, api_key: api_key,
            headers: headers, params: params 
          )

          [resp, opts]
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      protected def request(method, url, params = {}, opts = {})
        self.class.request(method, url, params, opts)
      end
    end
  end
end