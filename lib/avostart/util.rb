# frozen_string_literal: true

require 'cgi'

module Avostart
  module Util
    def self.object_classes
      @object_classes ||= Avostart::ObjectTypes.object_names_to_classes
    end

    # Converts a hash of fields or an array of hashes into a +AvostartObject+ or
    # array of +AvostartObject+s. These new objects will be created as a concrete
    # type as dictated by their `object` field (e.g. an `object` value of
    # `charge` would create an instance of +Charge+), but if `object` is not
    # present or of an unknown type, the newly created instance will fall back
    # to being a +AvostartObject+.
    #
    # ==== Attributes
    #
    # * +data+ - Hash of fields and values to be converted into a AvostartObject.
    # * +opts+ - Options for +AvostartObject+ like an API key that will be reused
    #   on subsequent API calls.
    def self.convert_to_avostart_object(data, opts = {})
      opts = opts
      object_class = opts[:object_class]
      case data
      when Array
        data.map { |i| convert_to_avostart_object(i, opts) }
      when Hash
        # Try converting to a known object class.  If none available, fall back
        # to generic AvostartObject
        object_classes.fetch(object_class, AvostartObject)
                      .construct_from(data, opts)
      else
        data
      end
    end
  end
end