# frozen_string_literal: true

module Avostart
  class AvostartObject
    include Enumerable

    def initialize(id = nil, opts = {})
      @opts = opts
      @values = {'id' => id}
    end

    def self.construct_from(values, opts = {})
      new.send(:initialize_from, values, opts)
    end

    def [](key)
      @values[key]
    end

    def to_hash
      @values
    end

    protected

    def metaclass
      class << self; self; end
    end

    def initialize_from(values, opts)
      @values = values.each_with_object({}) { |(k, v), h| h[k] = Util.convert_to_avostart_object(v, opts) }
      add_accessors(values)
      self
    end

    def add_accessors(values)
      metaclass.instance_eval do
        values.keys.each do |k|
          define_method(k) { @values[k] }
        end
      end
    end
  end
end
