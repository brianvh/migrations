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
