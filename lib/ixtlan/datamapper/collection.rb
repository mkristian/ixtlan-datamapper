require 'virtus'
module Ixtlan
  module DataMapper
    class Collection
      include Virtus.model( #:mass_assignments => false, 
                            :coerce => false )

      attribute :offset, Integer
      attribute :total_count, Integer

      def initialize( data, offset = nil, count = nil )
        super()
        self.total_count = data.count
        self.offset = offset.to_i
        last = ( count ? count.to_i : self.total_count ) - 1 + self.offset
        self.data = data[ self.offset..last ]
      end

      def data=( d )
        raise "not implemented"
      end

      def to_s
        "#{self.class}[ offset=#{offset} total_count=#{total_count} ]"
      end
    end
  end
end
