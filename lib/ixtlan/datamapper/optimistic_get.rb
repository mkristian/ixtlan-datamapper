#
# Copyright (C) 2012 mkristian
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'ixtlan/datamapper/stale_object_exception'
module Ixtlan
  module DataMapper
    module OptimisticGet

      def self.included(base)
        base.extend OptimisticGet
      end
      
      public

      def optimistic_get(updated_at, *args) 
        result = get( *args )
        if result
          check_stale( updated_at, result )
        end
      end
      
      def optimistic_get!(updated_at, *args)
        result = get!( *args )
        check_stale( updated_at, result )
      end

      private

      def check_stale( updated_at, result )
        unless updated_at
          raise StaleObjectException.new "no 'updated_at' given for #{self}."
        end
        if updated_at.is_a? String
          updated_at = DateTime.parse( updated_at.sub(/[.][0-9]+/, '') )
        end
        # rails hacky-de-hack
        if defined?( ActiveSupport::TimeWithZone ) && updated_at.is_a?( ActiveSupport::TimeWithZone )
          updated_at = updated_at.to_datetime
        end
        if updated_at != result.updated_at && updated_at.strftime("%Y:%m:%d %H:%M:%S") != result.updated_at.strftime("%Y:%m:%d %H:%M:%S")
          
          raise StaleObjectException.new "#{result.model} with key [#{result.id}] was updated at #{result.updated_at} is newer than #{updated_at}."
        end
        result
      end
    end

    ::DataMapper::Model.append_inclusions( OptimisticGet )
    ::DataMapper::Associations::OneToMany::Collection.send( :include,
                                                            OptimisticGet )
    ::DataMapper::Associations::ManyToMany::Collection.send( :include,
                                                             OptimisticGet )
  end
end
