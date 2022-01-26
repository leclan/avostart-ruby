# frozen_string_literal: true

module Avostart
  class Answer < APIResource
    OBJECT_NAME = 'answer'
    OBJECT_KEY = 'answer'

    def object_class
      Question::OBJECT_NAME
    end

    def object_key
      Question::OBJECT_KEY
    end


    def resource_url
      if self['id']
        "/case-files/#{self['id']}/question"
      else
        '/case-files'
      end
    end

  end
end
