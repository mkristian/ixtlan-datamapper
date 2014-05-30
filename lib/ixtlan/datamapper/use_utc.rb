ENV['TZ'] = 'UTC'
if defined? JRUBY_VERSION
  org.joda.time.DateTimeZone.setDefault(org.joda.time.DateTimeZone.forID('UTC'))
end
