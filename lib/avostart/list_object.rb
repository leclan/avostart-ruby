# frozen_string_literal: true

module Avostart
  class ListObject < AvostartObject
    include Enumerable
    include Avostart::APIOperations::List
    include Avostart::APIOperations::Request
    include Avostart::APIOperations::Create

    OBJECT_NAME = 'list'

    attr_accessor :filters

    def initialize(*args)
      super
      self.filters = {}
    end
  end
end