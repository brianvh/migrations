require 'acceptance/acceptance_helper'

feature "A Support user editing and managing a newly created group" do

  background do
    login_as :support, :uid => 55497, :name => nil
    users
    group
    visit path
  end

  subject { page }

  let(:users) { [
    create(:client, :firstname => 'Joe'),
    create(:client, :firstname => 'Jill'),
    create(:client, :firstname => 'Bob', :deptclass => depts[0]),
    create(:client, :firstname => 'Sam', :deptclass => depts[2]) ]
  }
  let(:depts) { %w[ Computing Test\ Group Library ] }
  let(:group) { create :group, :deptclass => depts[0..1].join(', ') }
  let(:path) { group_path group }

  context "Viewing the groups list page" do
    let(:path) { groups_path }

    it { should have_group group }
    it { should have_link group.name }
  end

  context "Viewing the group detail page" do
    it { should have_group_member users[2] }
    it { should_not have_group_member users[3] }
    it { should_not have_group_contacts }
  end

  context "After removing a member from the group" do
    before do
      within("#member-#{users[2].id}") { click_button 'Remove' }
    end

    it { should have_flash_notice 'Member was removed from group.' }
    it { should have_group_members 2 }
    it { should_not have_group_member users[2] }
  end

  context "After adding a deptclass, with 1 user, to the group" do
    before do
      click_link 'Add Deptclass'
      fill_in 'group_add_deptclass', :with => depts[2]
      click_button 'Add to Group'
    end

    it { should have_flash_notice '1 member added to group.' }
    it { should have_group_members 4 }
    it { should have_group_member users[3] }
  end

  context "After removing a deptclass, with 1 user, from the group" do
    before do
      click_link 'Remove Deptclass'
      fill_in 'group_remove_deptclass', :with => depts[0]
      click_button 'Remove from Group'
    end

    it { should have_flash_notice '1 member removed from group.' }
    it { should have_group_members 2 }
    it { should_not have_group_member users[2] }
  end
end
