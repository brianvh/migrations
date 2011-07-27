module WebauthHelpers

  def login_as(factory, opts={})
    user = Factory(factory, opts)
    webauth_valid_ticket_for('fake-webauth-ticket', user.name, user.uid)
    visit("/auth/cas/callback?ticket=fake-webauth-ticket")
    user
  end

  def webauth_valid_ticket_for(ticket, name, uid)
    webauth_setup_url(ticket, render_webauth_xml(name, uid))
  end

  def render_webauth_xml(name, uid)
    cas_xml = File.read("#{Rails.root.to_s}/spec/support/webauth_xml.erb")
    erb = ERB.new(cas_xml)
    erb.result(binding())
  end

  def webauth_setup_url(ticket, xml_text)
    url = "https://login.dartmouth.edu/cas/serviceValidate?"
    url << "ticket=#{ticket}"
    url << "&service=#{Rack::Utils.escape('http://www.example.com/auth/cas/callback')}"
    FakeWeb.clean_registry
    FakeWeb.register_uri(:get, url, :body => xml_text)
  end

end
