# frozen_string_literal: true

module Avostart
  class CaseFile < APIResource
    extend Avostart::APIOperations::Create
    extend Avostart::APIOperations::List

    OBJECT_NAME = 'case_file'
    OBJECT_KEY = 'case-files'
    OBJECT_PRIMARY_KEY = 'case_reference'
    custom_method :consultation, http_verb: :post

    def id
      self['id']
    end

    def object_class
      CaseFile::OBJECT_NAME
    end

    def object_key
      CaseFile::OBJECT_KEY
    end

    def primary_key
      CaseFile::OBJECT_PRIMARY_KEY
    end

    def resource_url
      if self['id']
        super
      else
        '/case-files'
      end
    end

    def self.resource_url
      '/case-files'
    end

    def self.create_resource_url
      '/case-files/create-from-question'
    end
  end
end