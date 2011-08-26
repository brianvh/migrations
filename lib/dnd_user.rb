module DNDUser

  def profile
    @profile ||= get_dnd_profile
  end

  def profile_fields
    %w(uid name firstname initials lastname deptclass expires netid email 
        emailsuffix mailboxtype affiliation blitzserv phone assignednetid)
  end

  def profile_to_attributes
    profile_fields.each do |field|
      send("#{field}=", profile.send(field)) if respond_to?("#{field}=")
    end
  end

  def cache_expires
    return unless profile_fields.include?('expires')
    return if profile.expires.blank?
    return unless respond_to?('expire_on=')
    expire_on = profile.expires.to_date
  end

  def get_dnd_profile
    dnd_prof = nil
    Net::DartmouthDND.start(profile_fields) do |dnd|
      dnd_prof = dnd.find(uid || name, :one)
    end
    dnd_prof
  end

  def valid_in_dnd?
    if name.nil? || uid.nil? # We haven't already performed a DND lookup
      unless profile # No unique match
        errors.add(:base, "No unique match for that user.")
        return false
      end
      profile_to_attributes # populate our attributes
    end
  end

  protected :profile_fields, :profile_to_attributes, :cache_expires,
            :get_dnd_profile, :valid_in_dnd?

end
