require 'lib/ldap_sync'

describe LDAPSync::Session do

  context "When creating a new instance" do
    let(:session) { LDAPSync::Session.new options }
    let(:base) { 'dc=dartmouth, dc=edu' }
    let(:options) { {:user => 'cn=Foo', :pass => 'fooPASS', :base => base} }

    subject { session }

    its(:host) { should == 'ldap.dartmouth.edu' }
    its(:dn) { should == "#{options[:user]}, #{options[:base]}" }
    its(:connection) { should be_an_instance_of LDAP::SSLConn }
  end

end

describe LDAPSync::Entry do

  let(:entry) { LDAPSync::Entry.new options, attrs }
  let(:attrs) { ['dnduid', 'dnddeptclass'] }
  let(:options) { {'dnduid' => uid, 'dnddeptclass' => dept, 'dn' => dn} }
  let(:uid) { ['101'] }
  let(:dept) { ['Test Group'] }
  let(:dn) { ["cn=#{cn}, #{base}"] }
  let(:cn) { 'Joe Client' }
  let(:base) { 'dc=dartmouth, dc=edu' }

  subject { entry }

  context "for an LDAP hash that contans all the attributes" do
    its(:cn) { should == cn }
    its(:dnduid) { should == uid.first }
    its(:dnddeptclass) { should == dept.first }
  end

  context "for a hash missing the 'dnddeptclass' attribute" do
    before { options.delete 'dnddeptclass' }

    its(:cn) { should == cn }
    its(:dnduid) { should == uid.first }
    its(:dnddeptclass) { should == nil }
  end

  context "for a hash missing the 'dn' attribute" do
    subject {}
    before { options.delete 'dn'}

    it "raises an error" do
      lambda { entry }.should raise_error('Entry hash missing the dn key.')
    end
  end

end

describe LDAPSync, '.uid_hash' do

  subject { LDAPSync.uid_hash(:filter => filter, :attrs => attrs, :auth => auth) }

  let(:filter) { '*' }
  let(:base) { 'dc=dartmouth, dc=edu' }
  let(:attrs) { ['dnduid', 'dnddeptclass'] }
  let(:auth) { {:user => 'cn=Fake User', :pass => 'fakePass', :base => base} }
  let(:dept) { 'Test Group' }
  let(:entries) { [
    ldap_hash(101, 'Jill Client', base, dept),
    ldap_hash(102, 'Joe Client', base, dept)
    ] }

  context "for a known set of DND entries" do
    let(:session) { stub(:users_by_uid => entries, :close => true) }

    before do
      LDAPSync::Session.should_receive(:new).once.and_return(session)
    end

    it { should have(2).items }
    it "returns the cn for Jill Client at key '101'" do
      subject['101'].cn.should == 'Jill Client'
    end
    it "returns the cn for Joe Client at key '102'" do
      subject['102'].cn.should == 'Joe Client'
    end
  end

end

def ldap_hash(uid, cn, dn_base, deptclass, expires=nil)
  {"dnduid"=>["#{uid}"], "dnddeptclass"=>[deptclass], "dndexpires" => expires,
    "dn"=>["cn=#{cn}, #{dn_base}"]}
end
