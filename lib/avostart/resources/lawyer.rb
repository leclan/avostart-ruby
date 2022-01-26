# frozen_string_literal: true

module Avostart
  class Lawyer < APIResource
    extend Avostart::APIOperations::List

    OBJECT_NAME = 'lawyer'
    OBJECT_KEY = 'lawyers'
    OBJECT_PRIMARY_KEY = 'id'

    def object_class
      Lawyer::OBJECT_NAME
    end

    def object_key
      Lawyer::OBJECT_KEY
    end

    def resource_url
      if self['id']
        super
      else
        '/case-files'
      end
    end

    def self.resource_url
      '/lawyers'
    end
  end
end
