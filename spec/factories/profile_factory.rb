Factory.define :profile do |f|
  f.used_email_clients ['Blitz[Mail]','GMail']
  f.migrate_oracle_calendar true
  f.uses_mail_forward true
  f.uses_local_mail true
  f.uses_ira true
  f.uses_hyperion true
  f.used_other_calendars true
  f.comfort_level '3'
end
