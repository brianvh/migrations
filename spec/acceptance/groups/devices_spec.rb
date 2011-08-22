require 'acceptance/acceptance_helper'

feature "A Support user viewing the devices associated with group members" do

  background do
    login
    members
    devices
    group
    visit path
  end

  subject { page }

  let(:login) { login_as :support, :uid => 55497, :name => nil }
  let(:members) { [
    create(:client, :firstname => 'Joe'),
    create(:client, :firstname => 'Jill')
    ] }
  let(:devices) { [
    create(:computer, :user => members[0]),
    create(:mobile, :user => members[0]),
    create(:mobile, :user => members[1], :vendor => 'Google')
    ] }
  let(:group) { create :group, :deptclass => members[0].deptclass }
  let(:path) { group_path group }

  context "Viewing the group detail members listing" do
    it { should have_group_members 2 }
    it { should have_group_member_devices members[0], 2 }
    it { should have_link 'View Devices' }

    context "After clicking the View Devices link" do
      before { click_link 'View Devices' }

      it { should have_link 'View Members' }
      it { should have_group_devices }
      it { should have_group_device devices[2] }
    end
  end
end
