require_relative 'spec_helper'

require 'ixtlan/datamapper/conditional_get'

class B
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  
  timestamps :at
end

DataMapper.finalize
DataMapper.auto_migrate!

describe Ixtlan::DataMapper::ConditionalGet do

  subject { B.create :name => 'huffalump' }

  describe "#conditional_get" do

    it 'returns false if everything is up-to-date' do
      B.conditional_get(subject.updated_at.to_s, subject.id).must_equal false
    end

    it 'returns false if everything is up-to-date with DateTime parameter' do
      B.conditional_get!(subject.updated_at, subject.id).must_equal false
    end
    
    it 'returns object for given id when there is no modified date' do
      B.conditional_get(nil, subject.id).must_equal subject
    end

    it 'returns nil on stale modified date' do
      B.conditional_get(subject.updated_at + 1, subject.id).must_equal subject
    end

    it 'returns nil on non-existing id' do
      B.conditional_get(subject.updated_at.to_s, subject.id + 987).must_be_nil
    end

  end

  describe "#conditional_get!" do

    it 'returns false if everything is up-to-date' do
      B.conditional_get!(subject.updated_at.to_s, subject.id).must_equal false
    end
    
    it 'returns false if everything is up-to-date with DateTime parameter' do
      B.conditional_get!(subject.updated_at, subject.id).must_equal false
    end
    
    it 'fails with not-found exception with non-existing id' do
      lambda { B.conditional_get!(subject.updated_at.to_s, subject.id + 987) }.must_raise DataMapper::ObjectNotFoundError
    end
    
    it 'retuens object with stale modified parameter' do
      B.conditional_get!((subject.updated_at - 1000).to_s, subject.id).must_equal subject
    end

    it 'returns object without modified parameter given' do
      B.conditional_get!(nil, subject.id).must_equal subject
    end

  end

end
