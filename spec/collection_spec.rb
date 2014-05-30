require_relative 'spec_helper'

require 'ixtlan/datamapper/collection'

class E
  include DataMapper::Resource

  property :id, Serial
  property :name, String

end

DataMapper.finalize
DataMapper.auto_migrate!

class ECollection < Ixtlan::DataMapper::Collection
  attribute :list, Array[E]
  def data=( d )
    self.list = d
  end
end

describe Ixtlan::DataMapper::Collection do

  before do
    (1..3).each do |i|
      unless d = E.get( i )
        d = E.new :name => 'huffalump', :id => i
        d.save!
      end
    end
  end

  it 'defaults to the complete set' do
    c = ECollection.new( E.all )
    c.total_count.must_equal E.count
    c.offset.must_equal 0
    c.list.must_equal E.all
  end

  it 'skips with given offset' do
    c = ECollection.new( E.all, offset = E.count )
    c.total_count.must_equal E.count
    c.offset.must_equal E.count
    c.list.must_equal []
  end

  (1..3).each do |i|
    it 'has only one element with offset and limit' do
      c = ECollection.new( E.all, offset = i - 1, 1 )
      c.total_count.must_equal E.count
      c.offset.must_equal i - 1
      c.list.must_equal [E.get( i )]
    end
  end

end
