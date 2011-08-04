require 'acceptance/acceptance_helper'

feature "Client Adding a New Device" do

  subject { page }

  before(:each) do
    @user = login_as :client
  end

  context "GIVEN: I'm a Client and need to create a new Device" do
    before do
      device_vendor_choices
      visit new_device_path
    end
    
    it { should have_header :device, "New Device Information for #{@user.name}"}
    it { should have_select_field(:device, :vendor_choice) }
    
    context "WHEN: I submit a valid Device, the resulting page" do
      before(:each) do
        select "Apple (Intel)", :from => "Vendor"
        click_button "Create Device"
      end
      
      it {should have_flash_notice "Success"}
      
    end
    
  end
  
end