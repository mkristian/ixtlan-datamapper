require 'dm-aggregates'
module Ixtlan
  module DataMapper
    module ConditionalGet

      def self.included(base)
        base.extend ConditionalGet
      end

      private

      ONE_SECOND = 1.0/86400

      def _conditional_get( method, modified_since, *id )
        if modified_since.is_a? String
          modified_since = DateTime.parse( modified_since.sub(/[.][0-9]+/, '') )
        end
        if modified_since.nil?
          self.send( method, *id )
        else
          query = Hash[ key.collect { |k| k.name }.zip( id ) ]
          query[ :updated_at.gte ] = modified_since
          query[ :updated_at.lte ] = modified_since + ONE_SECOND
          # return false when up-to-date
          # that helps to distinguish from nil which means not-found
          self.count( query ) == 0 ? self.send( method, *id ) : false
        end
      end

      public

      def conditional_get!( modified_since, *id )
        _conditional_get( :get!, modified_since, *id )
      end

      def conditional_get( modified_since, *id )
        _conditional_get( :get, modified_since, *id )
      end
    end
    ::DataMapper::Model.append_inclusions( ConditionalGet )
    ::DataMapper::Associations::OneToMany::Collection.send( :include,
                                                            ConditionalGet )
    ::DataMapper::Associations::ManyToMany::Collection.send( :include,
                                                             ConditionalGet )
  end
end
