require 'acceptance/acceptance_helper'

feature "A Support user creating, and viewing, a group of users" do

  background do
    login_as :support
  end

  subject { page }

  context "GIVEN: There are 3 users, across 2 deptclasses" do
    let(:dept) { 'Computing' }
    let(:users) { [
      create(:client, :firstname => "Bob", :deptclass => dept),
      create(:client, :firstname => "Jill", :deptclass => dept),
      create(:client) ] }
    let(:submit) {
      fill_in 'group_name', :with => group_fill
      fill_in 'group_deptclass', :with => dept_fill
      click_button "Create Group" }
    let(:group_fill) { 'Computing Services' }

    before { users }

    context "WHEN: I visit the New Group form" do
      before { visit new_group_path }

      it { should have_text_field :group, :name }
      it { should have_text_field :group, :week_of }
      it { should have_text_field :group, :deptclass }
      it { should have_button 'Create Group' }

      context "AND: I create a group with no deptclass(es)" do
        let(:dept_fill) { '' }

        before { submit }

        it { should have_flash_notice "New group created. 0 users added." }
        it { should have_header :group, "Group Information for Computing Services" }
        it { should have_no_group_members }
      end

      context "AND: I create a group with 'Computing' as the deptclass" do
        let(:dept_fill) { dept }

        before { submit }

        it { should have_flash_notice "New group created. 2 users added." }
        it { should have_group_members 2 }
        it { should have_group_member users[0] }
        it { should have_group_member users[1] }
        it { should_not have_group_member users[2] }
      end

      context "AND: I create a group with 'Computing, Test Group' as the deptclasses" do
        let(:dept_fill) { "#{dept}, Test Group" }

        before { submit }

        it { should have_flash_notice "New group created. 3 users added." }
        it { should have_group_members 3 }
        it { should have_group_member users[2] }
      end
    end
  end
end
