# -*- mode: ruby -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-datamapper'
  s.version = '0.1.0'

  s.summary = ''
  s.description = s.summary
  s.homepage = 'http://github.com/mkristian/ixtlan-datamapper'

  s.authors = ['mkristian']
  s.email = ['m.kristian@web.de']

#   s.files = Dir['MIT-LICENSE']
#   s.licenses << 'MIT'
# #  s.files += Dir['History.txt']
#   s.files += Dir['README.md']
#   s.rdoc_options = ['--main','README.md']
#   s.files += Dir['lib/**/*']
#   s.files += Dir['spec/**/*']
#   s.test_files += Dir['spec/**/*_spec.rb']
  s.add_runtime_dependency 'virtus', '~>1.0'
#   s.add_development_dependency 'minitest', '~>5.0'
#   s.add_development_dependency 'dm-timestamps', '1.2.0'
  s.add_runtime_dependency 'dm-aggregates'
#   s.add_development_dependency 'dm-sqlite-adapter', '1.2.0'
#   s.add_development_dependency 'rake', '~>10.0.2'
end

# vim: syntax=Ruby
