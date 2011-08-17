require 'acceptance/acceptance_helper'

feature "Different User types trying to view the detail of an existing Group" do

  background do
    login
    group
    visit path
  end

  subject { page }

  let(:login) { login_as :client, :uid => 58789, :name => nil }
  let(:group) { create :group }
  let(:path) { group_path group }

  context "A Support user viewing the Group's detail page" do
    let(:login) { login_as :support, :uid => 55497, :name => nil }

    it { should have_header :group, "Group Information for #{group.name}" }
    it { should have_link "Choose a Contact" }
    it { should have_link "Add Member" }
    it { should have_link "Add Deptclass" }
    it { should have_link "Remove Deptclass" }
    it { should have_link "Choose a Consultant" }
  end

  context "A Client Key Contact viewing the Group's detail page" do
    let(:group) { create :group, :contacts => [login] }

    it { should have_group_contact login }
    it { should_not have_link "Choose a Contact" }
    it { should_not have_clear_contact login }
    it { should_not have_link "Add Member" }
    it { should_not have_link "Add Deptclass" }
    it { should_not have_link "Remove Deptclass" }
    it { should_not have_link "Choose a Consultant" }
  end

  context "A Client user trying to view the Group's detail page" do
    it { should have_header :user, "User Status for #{login.name}" }
  end
end
