# -*- mode: ruby -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-datamapper'
  s.version = '0.1.0'

  s.summary = 'collection of utilities for datamapper'
  s.description = 'collection of utilities for datamapper: optimistic get, conditional get, use-utc timestampt, tag model as immutable, etc'
  s.homepage = 'http://github.com/mkristian/ixtlan-datamapper'

  s.authors = ['mkristian']
  s.email = ['m.kristian@web.de']

  s.files = Dir['MIT-LICENSE']
  s.licenses << 'MIT'
  #  s.files += Dir['History.txt']
  s.files += Dir['*.gemspec']
  s.files += Dir['README.md']
  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*']
  s.files += Dir['*file']
  s.test_files += Dir['spec/**/*_spec.rb']
  s.add_runtime_dependency 'virtus', '~>1.0'
  s.add_runtime_dependency 'dm-aggregates', '~>1.2'
  s.add_development_dependency 'rake', '~>10.3'
  s.add_development_dependency 'minitest', '~>5.3'
end

# vim: syntax=Ruby
