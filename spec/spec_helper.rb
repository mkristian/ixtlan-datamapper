# single spec setup
$LOAD_PATH.unshift File.expand_path( '../../lib', __FILE__ )

gem 'minitest'
require 'minitest/autorun'

require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'
require 'dm-sqlite-adapter'

require 'ixtlan/datamapper/use_utc'

DataMapper.setup(:default, 'sqlite::memory:')
