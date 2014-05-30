require_relative 'spec_helper'

require 'ixtlan/datamapper/immutable'

class C
  include DataMapper::Resource
  include Ixtlan::DataMapper::Immutable

  property :id, Serial
  property :name, String
  
  timestamps :at
end

DataMapper.finalize
DataMapper.auto_migrate!

describe Ixtlan::DataMapper::Immutable do

  subject { C.create :name => 'huffalump' }

  it 'is valid and persistent' do
    subject.valid?.must_equal true
    subject.persistence_state?.must_equal true
  end

  it 'is valid and persistent' do
    subject.name = 'noone'
    subject.valid?.must_equal false
    subject.save.must_equal false
  end

end
