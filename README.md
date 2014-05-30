# Ixtlan DataMapper #

* [![Build Status](https://secure.travis-ci.org/mkristian/ixtlan-datamapper.png)](http://travis-ci.org/mkristian/ixtlan-datamapper)
* [![Dependency Status](https://gemnasium.com/mkristian/ixtlan-datamapper.png)](https://gemnasium.com/mkristian/ixtlan-datamapper)
* [![Code Climate](https://codeclimate.com/github/mkristian/ixtlan-datamapper.png)](https://codeclimate.com/github/mkristian/ixtlan-datamapper)


it adds optimistic persistence support to DataMapper and ActveRecord using the updated\_at property/attribute which is automatically updated on any change of the model (for datamapper you need dm-timestamps for that). to load a model use `optimistic_get`/`optimistic_get!`/`optimistic_find` respectively where the first argument is the last `updated_at` value which the client has. if the client data is uptodate then the `optimistic_XYZ` method will return the database entity otherwise raise an exception or return nil respectively.


## optimistic/conditional get ##

just include `require 'ixtlan/datamapper/optimistic'` and have model like:

    class User
      include DataMapper::Resource

      property :id, Serial
      property :name, String
  
      timestamps :at
    end
	
you need the timestamps to get it to work since the updated_at property will be used to determine if the object is stale or not.

now you get the object in an optimistic manner

    User.optimistic_get!( updated_at, id )
    User.optimistic_get( updated_at, id )

if will raise an Ixtlan::DataMapper::StaleObjectException in case the object with the given ```id``` exists but does carry a different updated_at timestamp. otherwise the ```optimistic_get``` and ```optimistic_get!``` behave the same as ```get``` and ```get!```.

now you get the object in an conditional manner

    User.conditinal_get!( updated_at, id )
    User.conditional_get( updated_at, id )

it the ```User``` when the updated_at does not match. when it matches it returns ```false```. in case the ```id``` does not exist, it will return either nil of DataMapper::ObjectNotFoundError. this allows constructs like

    if u = User.conditinal_get!( request.last_modified, id )
	  response.last_modified = u.updated_at
	  response.write ....
    else
	  # in case request.last_modified was nil
	  response.last_modified = u.updated_at	  
	end

## Ixtlan::DataMapper::Immutable ##

    class Group
      include DataMapper::Resource
	  include Ixtlan::DataMapper::Immutable

      property :id, Serial
      property :name, String
    end

you can create and delete those object but any attempt to change it the name ends in validation error.

## require 'ixtlan/datamapper/use_utc' ##

just convenient file to setup datamapper to use UTC timestamps

## Ixtlan::DataMapper:Collection ##

the collection is [virtus](http://github.com/solnic/virtus) object which helps to transport collections of DataMapper objects around. it has the ```total_count``` and an ```offset``` along an accessor for the list. the contructor deals with offset and limit on the datamapper query.

    class UserCollection < Ixtlan::DataMapper::Collection
      attribute :users, Array[User]
      def data=( d )
        self.users = d
      end
    end

this

    UserCollection.new( User.all( :name.like => 'a%' ), 20, 10 )

will return 10 users starting with 'a' starting with 20th user from all possible users (with 'a').


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

meta-fu
-------

enjoy :) 
