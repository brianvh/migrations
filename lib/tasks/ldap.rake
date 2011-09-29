
namespace :ldap do

  desc 'Synchronize all current users based on their LDAP status.'
  task :sync => :environment do
    ldap_hash = LDAPSync.uid_hash(:filter => '*', :attrs => ldap_attrs,
                                  :auth => ldap_auth)
    sync_status = User.sync_from_ldap(ldap_hash)
    p sync_status
    Webmaster.ldap_sync_notify(sync_status)
  end

  def ldap_attrs
    ['dnduid', 'dnddeptclass', 'dndexpires', 'mail', 'dndassignednetid']
  end

  def ldap_auth
    @ldap_auth ||= YAML.load_file("#{Rails.root}/../../shared/.ldap_auth")
  end

end
