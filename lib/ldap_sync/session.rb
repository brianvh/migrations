module LDAPSync

  class Session
    attr_reader :host, :dn, :base, :user, :password, :filter, :attributes

    def initialize(options={})
      @host = options[:host] || 'ldap.dartmouth.edu'
      @base = options[:base]
      @user = options[:user]
      @password = options[:pass]
      @dn = "#{@user}, #{@base}"
    end

    def connection
      @connection ||= get_connection
    end

    def close
      connection.unbind if connection.bound?
    end

    def users_by_uid(filter='*', attribs=[])
      login unless connection.bound?
      @filter = "(dnduid=#{filter})"
      @attributes = attribs
      get_users
    end

    def self.start(options, &block)
      session = Session.new(options)
      return session unless block_given?
      begin
        yield session
      ensure
        session.close
      end
    end

    private

    def get_connection
      LDAP::SSLConn.new(host, LDAP::LDAPS_PORT)
    end

    def login
      connection.bind(dn, password)
    end

    def scope
      LDAP::LDAP_SCOPE_SUBTREE
    end

    def get_users
      connection.search2(base, scope, filter, attributes)
    end
  end

end
