Factory.define :profile do |f|
  f.used_email_clients ['Blitz[Mail]','GMail']  #.to_yaml
  f.migrate_oracle_calendar true
end
