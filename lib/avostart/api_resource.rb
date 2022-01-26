# frozen_string_literal: true

module Avostart
  class APIResource < AvostartObject

    include Avostart::APIOperations::Request
    attr_accessor :values

    def self.class_name
      name.split('::')[-1]
    end

    def self.resource_url
      if self == APIResource
        raise NotImplementedError,
              'APIResource is an abstract class. You should perform actions ' \
              'on its subclasses (Charge, Customer, etc.)'
      end
      # Namespaces are separated in object names with periods (.) and in URLs
      # with forward slashes (/), so replace the former with the latter.
      "/v1/#{self::OBJECT_NAME.downcase.tr('.', '/')}s"
    end

    def self.create_resource_url
      resource_url
    end

    # Adds a custom method to a resource class. This is used to add support for
    # non-CRUDL API requests, e.g. capturing charges. custom_method takes the
    # following parameters:
    # - name: the name of the custom method to create (as a symbol)
    # - http_verb: the HTTP verb for the API request (:get, :post, or :delete)
    # - http_path: the path to append to the resource's URL. If not provided,
    #              the name is used as the path
    #
    # For example, this call:
    #     custom_method :capture, http_verb: post
    # adds a `capture` class method to the resource class that, when called,
    # will send a POST request to `/v1/<object_name>/capture`.
    def self.custom_method(name, http_verb:, http_path: nil)
      unless %i[get post delete patch put].include?(http_verb)
        raise ArgumentError,
              "Invalid http_verb value: #{http_verb.inspect}. Should be one " \
              'of :get, :post or :delete.'
      end
      http_path ||= name.to_s
      define_singleton_method(name) do |id, params = {}, opts = {}|
        url = "#{resource_url}/#{id}/#{CGI.escape(http_path)}"
        parsed_params = [:post, :patch, :put].include?(http_verb) ? { body: params } : { query: params }
        resp, opts = request(http_verb, url, parsed_params, opts)
        Util.convert_to_avostart_object(resp.data, opts)
      end
    end

    def resource_url
      unless id
        raise InvalidRequestError.new(
          "Could not determine which URL to request: #{self.class} instance " \
          "has invalid ID: #{id.inspect}",
          'id'
        )
      end
      "#{self.class.resource_url}/#{id}"
    end

    def refresh
      resp, opts = request(:get, resource_url)
      data = resp.data[self.class::OBJECT_KEY.to_s]
      raise Avostart::NotFoundError unless data.present?

      initialize_from(data, opts)
    end

    def self.retrieve(id, opts = {})
      instance = new(id, opts)
      instance.refresh
      instance
    end

    class << self
      alias fetch retrieve
    end
  end
end
