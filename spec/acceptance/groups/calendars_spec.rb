require 'acceptance/acceptance_helper'

feature "A Support user viewing calendars associated with group members" do

  background do
    login
    client
    calendar
    group
    visit path
  end

  subject { page }

  let(:login) { login_as :support, :uid => 55497, :name => nil }
  let(:client) { create :client }
  let(:calendar) { create :resource, :primary_owner => client }
  let(:group) { create :group, :deptclass => client.deptclass, :action => :create }
  let(:path) { group_path group }

  context "Viewing a group, with a member, with no calendar resources" do
    let(:calendar) { nil }

    it { should have_group_member client }
    it { should_not have_group_calendars }
  end

  context "Viewing a group, with a member, with 1 calendar resource" do
    it { should have_group_calendars }
    it { save_and_open_page ; should have_group_calendar calendar }
  end
end
