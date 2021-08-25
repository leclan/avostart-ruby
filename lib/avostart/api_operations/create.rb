# frozen_string_literal: true

module Avostart
  module APIOperations
    module Create
      def create(params = {}, opts = {})
        resp, opts = request(:post, create_resource_url, { body: params }, opts)
        return true if resp.data.empty? && resp.http_status.success?
        
        Util.convert_to_avostart_object(resp.data[self::OBJECT_KEY]&.first, opts.merge(object_class: self::OBJECT_NAME))
      end
    end
  end
end
