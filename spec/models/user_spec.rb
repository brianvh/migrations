require 'spec_helper'

describe "A new Client User instance" do

  subject { client }

  context "Created with both first and last name attributes" do
    let(:client) { build :client }

    its(:last_first) { should == 'Client, Joe' }
  end

  context "Created with a last name attribute" do
    let(:client) { build :client, :firstname => '' }

    its(:last_first) { should == 'Client' }
  end
end

describe "An existing User instance, updating from the DND" do

  subject { user }

  let(:last_update) { 1.day.ago }
  let(:client) { create :client, :uid => 58789, :name => nil }
  let(:user) { client }

  context "When the user was last updated, yesterday" do
    before { client.update_attribute :updated_at, last_update }

    its(:needs_resync?) { should be(true) }

    context "and we ask for the DND profile" do
      let(:client_id) { client.id }
      let(:user) { User.find client_id }

      before { user.profile }

      its(:needs_resync?) { should be(false) }
    end
  end
end

describe "Finding users by their deptclass values" do
  subject { User.find_for_deptclass(deptclass, exclude_ids) }

  let(:users) { [
    create(:client, :firstname => 'Joe'),
    create(:client, :firstname => 'Jill') ]
  }
  let(:deptclass) { users[0].deptclass }

  context "excluding no users" do
    let(:exclude_ids) { [] }

    it { should have(2).items }
  end

  context "excluding the first user" do
    let(:exclude_ids) { [users[0].id] }

    it { should have(1).items }
  end

  context "excluding all users" do
    let(:exclude_ids) { [users[0].id, users[1].id] }

    it { should have(0).items }
  end
end

describe "Syncing users from the daily LDAP hash" do

  let(:users) { [
    create(:client, :firstname => 'Joe'),
    create(:client, :firstname => 'Jill') ]
  }
  let(:stub1) { ldap_stub(101, 'Test Group') }
  let(:stub2) { ldap_stub(102, 'Computing') }
  let(:ldap_hash) { {stub1.dnduid => stub1, stub2.dnduid => stub2} }

  before { users }

  subject { User.sync_from_ldap(ldap_hash) }

  context "When the number of users is constant" do
    its([:updated]) { should == 2 }
    its([:added]) { should == 0 }
    its([:expired]) { should == 0 }
  end

  context "When a new user is present" do
    let(:stub3) { ldap_stub(58789, 'Computing') }
    before { ldap_hash[stub3.dnduid] = stub3 }

    its([:updated]) { should == 2 }
    its([:added]) { should == 1 }
  end

  context "When a user is no longer present" do
    
  end
end

def ldap_stub(uid, dept, expires=nil)
  stub(:dnduid => uid, :dnddeptclass => dept, :dndexpires => expires)
end