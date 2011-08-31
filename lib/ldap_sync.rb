require 'ldap'
require 'ldap_sync/session'
require 'ldap_sync/entry'

module LDAPSync

  def self.uid_hash(options={})
    users = []
    Session.start(options[:auth]) do |ldap|
      users = ldap.users_by_uid(options[:filter], options[:attrs])
    end
    users.map! { |user| new_entry(user, options[:attrs]) }
    users.inject({}) { |hash, user| hash[user.dnduid] = user ; hash }
  end

  def self.new_entry(user_hash, attrs)
    Entry.new(user_hash, attrs)
  end

end
