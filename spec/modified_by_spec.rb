require_relative 'spec_helper'

require 'ixtlan/datamapper/modified_by'

class D
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  
  modified_by D
end

DataMapper.finalize
DataMapper.auto_migrate!

describe Ixtlan::DataMapper::ModifiedBy do

  subject do 
    unless d = D.get( 1 )
      d = D.new :name => 'huffalump', :id => 1, :modified_by_id => 1
      d.save!
    end
    d
  end

  it 'is valid per default' do
    subject.current_user.must_be_nil
    subject.persistence_state?.must_equal true
    subject.dirty?.must_equal false
    subject.valid?.must_equal true
  end

  it 'is not valid when dirty' do
    subject.name = 'asd'
    subject.current_user.must_be_nil
    subject.dirty?.must_equal true
    subject.valid?.must_equal false
  end

  it 'is valid when dirty and current_user set' do
    subject.name = 'asd'
    subject.current_user = subject
    subject.dirty?.must_equal true
    subject.valid?.must_equal true
  end

  it 'is valid after setting current user' do
    subject.current_user = subject
    subject.dirty?.must_equal false
    subject.valid?.must_equal true
  end

end
