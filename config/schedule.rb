every :day, :at => Chronic.parse('5 minutes from now') do
  rake "ldap:sync"
end
