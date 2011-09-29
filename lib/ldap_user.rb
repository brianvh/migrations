module LDAPUser
 extend ActiveSupport::Concern

 included do
   cattr_reader :ldap_users, :instance_reader => false
   cattr_reader :sync_results, :instance_reader => false
   cattr_writer :update_uids, :instance_writer => false
   cattr_writer :update_users, :instance_writer => false
   cattr_writer :expire_uids, :instance_writer => false
   cattr_writer :add_uids, :instance_writer => false
 end

 module ClassMethods

   def sync_from_ldap(ldap_hash)
     start_sync(ldap_hash)
     update_from_ldap
     add_from_ldap
     expire_from_ldap
     sync_results
   end

   def start_sync(ldap_hash = {})
     set_attr(:ldap_users, ldap_hash)
     reset_results
   end

   def reset_results
     set_attr(:sync_results, {:updated => 0, :added => 0, :expired => 0})
   end

   def update_from_ldap
     update_uids.each do |uid|
       expire_uid(uid) and next unless ldap_users.has_key?(uid)
       update_users[uid].update_from_ldap_entry(ldap_users[uid])
     end
     sync_results[:updated] = (update_uids - expire_uids).size
   end

   def add_from_ldap
     add_uids.each { |uid| Client.create(:uid => uid) }
     sync_results[:added] = add_uids.size
   end

   def expire_from_ldap
     sync_results[:expired] = expire_uids.inject(0) { |sum, uid| sum + update_users[uid].deactivate_from_ldap }
   end

   def update_users
     set_attr(:update_users, update_users_hash) if get_attr(:update_users).nil?
     get_attr(:update_users)
   end

   def update_uids
     set_attr(:update_uids, update_users.keys.sort) if get_attr(:update_uids).nil?
     get_attr(:update_uids)
   end

   def update_users_hash
     User.all.inject({}) { |hash, user| hash[user.uid] = user ; hash }
   end

   def add_uids
     set_attr(:add_uids, uids_to_add) if get_attr(:add_uids).nil?
     get_attr(:add_uids)
   end

   def expire_uids
     set_attr(:expire_uids, []) if get_attr(:expire_uids).nil?
     get_attr(:expire_uids)
   end

   def expire_uid(uid)
     expire_uids << uid
   end

   def uids_to_add
    (ldap_users.keys.sort - (update_uids - expire_uids)).sort
   end

   def get_attr(var)
     class_variable_get("@@#{var}")
   end

   def set_attr(var, value=nil)
     class_variable_set("@@#{var}", value)
   end

 end

 module InstanceMethods

   def update_from_ldap_entry(entry)
     self.deptclass = entry.dnddeptclass unless entry.dnddeptclass.nil?
     self.expire_on = entry.dndexpires.to_date unless entry.dndexpires.nil?
     self.email = entry.mail unless entry.mail.nil?
     self.assignednetid = entry.dndassignednetid unless entry.dndassignednetid.nil?
     self.save
   end

   def deactivate_from_ldap
     return 0 if self.expired?
     self.deactivate
     return 1
   end

 end
end
