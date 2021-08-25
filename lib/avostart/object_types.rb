# frozen_string_literal: true

module Avostart
  module ObjectTypes
    def self.object_names_to_classes
      {
        # data structures
        ListObject::OBJECT_NAME => ListObject,
        # business objects
        Product::OBJECT_NAME => Product,
        CaseFile::OBJECT_NAME => CaseFile,
        Lawyer::OBJECT_NAME => Lawyer,
      }
    end
  end
end
