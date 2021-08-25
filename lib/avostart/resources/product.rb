# frozen_string_literal: true

module Avostart
  class Product < APIResource
    extend Avostart::APIOperations::List

    OBJECT_NAME = 'product'
    OBJECT_KEY = 'products'

    def object_class
      Product::OBJECT_NAME
    end

    def object_key
      Product::OBJECT_KEY
    end

    def resource_url
       '/products'
    end

    def self.resource_url
      '/products'
    end
  end
end