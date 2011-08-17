require 'acceptance/acceptance_helper'

feature "A Client user viewing their status page" do

  background do
    user
    group
    profile
    devices
    resources
    visit user_path(user)
  end

  let(:user) { @user = login_as :client, :uid => 58789, :name => nil }
  let(:group) { create :group, :name => "Class '17", :deptclass => "'17" }
  let(:profile) { create :profile, :user => user }
  let(:devices) {
    @user.devices << Computer.new({:vendor => 'Apple', :kind => 'Laptop'})
    @user.devices << Mobile.new({:vendor => 'Apple', :kind => 'Smartphone'})
  }
  let(:resources) { 
    @resource = Factory(:resource)
    @user.primary_resource_ownerships << @resource
    }
  subject { page }

  context "Visit their status page, with no profile or devices, and not a key contact" do
    let(:profile) { nil }
    let(:devices) { nil }
    let(:resources) { nil }

    it { should have_group_name group.name }
    it { should_not have_link group.name }
    it { should_not have_profile_info }
    it { should_not have_devices_list }
    it { should_not have_resources_list }
  end

  context "Visiting their status page, with a submitted profile" do
    let(:devices) { nil }

    it { should have_profile_info }
  end

  context "Visiting their status page, with 2 devices (1 computer, 1 mobile)" do
    let(:profile) { nil }

    it { should have_devices_list }
  end
  
  context "Visiting their status page, with one resource" do
    let(:profile) { nil }
    let(:devices) { nil }
    
    it { should have_resources_list }
    
  end
  
  context "Visiting their status page, as a group key contact, showing their group name as a link" do
    let(:profile) { nil }
    let(:devices) { nil }
    let(:resources) { nil }
    let(:group) { create :group, :name => "Class '17", :deptclass => "'17", :contacts => [@user] }
    
    it { should have_group_name group.name }
    it { should have_link group.name }
    
  end
  
end
