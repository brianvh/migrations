require 'acceptance/acceptance_helper'

feature "A Support user editing and managing a newly created group" do

  background do
    login
    users
    group
    visit path
  end

  subject { page }

  let(:login) { login_as :support, :uid => 55497, :name => nil }
  let(:users) { [
    create(:client, :firstname => 'Joe'),
    create(:client, :firstname => 'Jill'),
    create(:client, :firstname => 'Bob', :deptclass => depts[0]),
    create(:client, :firstname => 'Sam', :deptclass => depts[2]),
    create(:support, :firstname => 'Jack') ]
  }
  let(:depts) { %w[ Computing Test\ Group Library ] }
  let(:group) { create :group, :deptclass => depts[0..1].join(', ') }
  let(:path) { group_path group }
  let(:member_name) { login.name }
  let(:add_member) {
    click_link 'Add Member'
    fill_in :group_member_name, :with => member_name
    click_button 'Add Member' }
  let(:choose_contact) {
    click_link 'Choose a Contact'
    select users[2].last_first, :from => 'Choose a Member'
    click_button 'Add Contact' }
  let(:choose_consultant) {
    click_link 'Choose a Consultant'
    select login.last_first, :from => 'Choose a Consultant'
    click_button 'Assign Consultant' }

  context "Viewing the groups list page" do
    let(:path) { groups_path }

    it { should have_group group }
    it { should have_link group.name }
  end

  context "Viewing the group detail page" do
    it { should have_group_member users[2] }
    it { should_not have_group_member users[3] }
    it { should_not have_group_contacts }
    it { should_not have_group_consultants }
  end

  context "After removing a member from the group" do
    before do
      within("#member-#{users[2].id}") { click_button 'Remove' }
    end

    it { should have_flash_notice 'Member was removed from group.' }
    it { should have_group_members 2 }
    it { should_not have_group_member users[2] }
  end

  context "After adding a member to the group, by name" do
    before do
      add_member
    end

    it { should have_flash_notice "Member \"#{member_name}\" added to group." }
    it { should have_group_member_name member_name }
  end

  context "After trying to add a member with an invalid name" do
    let(:member_name) { 'Bad Name' }

    before do
      add_member
    end

    it { should have_flash_error %("#{member_name}" is not a unique match) }
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

  context "After choosing a Key Contact for the group" do
    before do
      choose_contact
    end

    it { should have_flash_notice "#{users[2].last_first} added as a Key Contact." }
    it { should have_group_contact users[2] }
    it { should_not have_group_member users[2] }
  end

  context "After clearing an existing Key Contact" do
    before do
      choose_contact
      within("#contact-#{users[2].id}") { click_button 'Clear Contact' }
    end

    it { should have_flash_notice "#{users[2].last_first} removed as a Key Contact." }
    it { should_not have_group_contacts }
    it { should have_group_member users[2] }
  end

  context "After assigning a Support Consultant for the group" do
    before do
      choose_consultant
    end

    it { should have_flash_notice "#{login.last_first} assigned as a Support Consultant." }
    it { should have_group_consultant login }
    it { should_not have_consultant_choice login }
  end

  context "After un-assigning a Support Consultant" do
    before do
      choose_consultant
      within("#consultant-#{login.id}") { click_button 'Unassign' }
    end

    it { should have_flash_notice "#{login.last_first} un-assigned as a Support Consultant." }
    it { should_not have_group_consultants }
    it { should have_consultant_choice login }
  end
end
