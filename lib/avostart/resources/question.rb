# frozen_string_literal: true

module Avostart
  class Question < APIResource

    OBJECT_NAME = 'question'
    OBJECT_KEY = 'questions'

    def id
      self['id']
    end

    def object_class
      Question::OBJECT_NAME
    end

    def object_key
      Question::OBJECT_KEY
    end


    def resource_url
      byebug
      if self['id']
        "/case-files/#{self['id']}/question"
      else
        '/case-files'
      end
    end

  end
end