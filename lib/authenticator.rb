class Authenticator

  attr_reader :auth_hash

  def initialize(hash)
    @auth_hash = hash
  end

  def provider
    @provider ||= auth_hash['provider'].to_sym
  end

  def realm
    @realm ||= realm_from_user_host
  end

  def uid
    @uid ||= auth_hash['extra']['uid'].to_i
  end

  def self.from_hash(hash)
    auth = Authenticator.new(hash)
    return nil unless auth.provider == :cas
    return nil unless auth.realm == :dartmouth
    auth
  end

  private

  def user_host
    @user_host ||= auth_hash['uid'].split(/@/)[1].downcase
  end

  def realm_from_user_host
    case user_host
      when 'dartmouth.edu'      then :dartmouth
      when 'alum.dartmouth.org' then :alumni
      when 'hitchcock.org'      then :hitchcock
      else nil
    end
  end
end
