Factory.define :profile do |f|
  f.used_email_clients ['Blitz[Mail]','GMail']
  f.migrate_oracle_calendar true
  f.comfort_level '3'
end
