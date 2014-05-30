module Ixtlan
  module DataMapper
    module Immutable
      def self.included( model )
        model.class_eval do
          validates_with_method :validate_immutable
        end
      end
      def validate_immutable
        if dirty? && ! new?
          [ false, 'object is immutable' ]
        else
          true
        end
      end
    end
  end
end
