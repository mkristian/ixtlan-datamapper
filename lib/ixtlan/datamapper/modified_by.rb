module Ixtlan
  module DataMapper
    module ModifiedBy

      def current_user=( user )
        @_current_user = user
      end

      def current_user
        @_current_user
      end

      def _modified_by
        self.modified_by = @_current_user if dirty? && @_current_user
      end

      def validate_modified_by
        if @_current_user || ! dirty?
          true
        else
          [ false, 'current_user was not set' ]
        end
      end

      module Methods
        def modified_by( *args )
          belongs_to :modified_by, *args

          before :valid?, :_modified_by

          validates_with_method :validate_modified_by
        end
      end

      ::DataMapper::Model.append_inclusions self
      ::DataMapper::Model.append_extensions Methods
    end
  end
end
