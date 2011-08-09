require 'acceptance/acceptance_helper'

feature "A Client user viewing their status page" do

  background do
    user
    group
    profile
    devices
    visit user_path(user)
  end

  let(:user) { login_as :client, :uid => 58789, :name => nil }
  let(:group) { create :group, :name => "Class '17", :deptclass => "'17" }
  let(:profile) { create :profile, :user => user }
  let(:devices) { [
    create(:computer, :user => user),
    create(:mobile, :user => user) ] }

  subject { page }

  context "Visit their status page, with no profile or devices" do
    let(:profile) { nil }
    let(:devices) { nil }

    it { should have_group_name group.name }
    it { should_not have_profile_info }
    it { should_not have_devices_list }
  end

  context "Visiting their status page, with a submitted profile" do
    let(:devices) { nil }

    it { should have_profile_info }
  end

  context "Visiting their status page, with 2 devies (1 computer, 1 mobile)" do
    let(:profile) { nil }

    it { save_and_open_page ; should have_devices_list }
  end
end
