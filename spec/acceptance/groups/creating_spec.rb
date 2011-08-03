require 'acceptance/acceptance_helper'

feature "A Support user creating, and viewing, a group of users" do

  background do
    login_as :support
  end

  subject { page }

  let(:users) { [
    create(:client, :uid => 102, :firstname => "Bob", :deptclass => dept),
    create(:client, :uid => 103, :firstname => "Jill", :deptclass => dept),
    create(:client) ] }
  let(:dept) { 'Computing' }

  context "GIVEN: There are 3 users, across 2 deptclasses" do
    before { users }

    context "WHEN: I visit the New Group form" do
      before { visit new_group_path }

      it { should have_form_field :group, :name }
      it { should have_form_field :group, :week_of }
      it { should have_form_field :group, :deptclass }
      it { should have_button 'Create Group' }

      context "AND: I create a group with no deptclass(es)" do
        before do
          fill_in 'group_name', :with => "Computing Services"
          click_button "Create Group"
        end

        it { should have_flash_notice "New group created. 0 users added." }
        it { should have_header :group, "Group Info for Computing Services" }
        it { should have_no_group_members }
      end

      context "AND: I create a group with 'Computing' as the deptclass" do
        before do
          fill_in 'group_name', :with => "Computing Services"
          fill_in 'group_deptclass', :with => dept
          click_button "Create Group"
        end

        it { should have_flash_notice "New group created. 2 users added." }
        it { should have_group_members 2 }
        it { should have_group_member users[0] }
        it { should have_group_member users[1] }
        it { should_not have_group_member users[2] }
      end
    end
  end
end
