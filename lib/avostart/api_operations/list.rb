# frozen_string_literal: true

module Avostart
  module APIOperations
    module List
      def list(filters = {}, opts = {})
        resp, opts = request(:get, resource_url, { query: filters }, opts)
        ListObject.construct_from(resp.data, opts.merge(object_class: self::OBJECT_NAME))
      end

      # The original version of #list was given the somewhat unfortunate name of
      # #all, and this alias allows us to maintain backward compatibility (the
      # choice was somewhat misleading in the way that it only returned a single
      # page rather than all objects).
      alias all list
    end
  end
end