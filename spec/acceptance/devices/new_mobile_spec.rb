require 'acceptance/acceptance_helper'

feature "Client Adding a New 'Mobile' Device" do

  subject { page }

  before(:each) do
    @user = login_as :client
  end

  context "GIVEN: I'm a Client and need to create a new 'Mobile' Device" do
    before do
      device_mobile_vendor_choices
      device_mobile_kind_choices
      visit new_device_path(:type => 'mobile')
    end
    
    it { should have_header :device, "New Mobile Device Information"}
    it { should have_select_field(:device, :vendor_choice) }
    
    context "WHEN: I submit a valid Device, the resulting page" do
      before(:each) do
        select "Apple", :from => "Vendor"
        select "Phone", :from => "Kind"
        click_button "Create Device"
        @device = Device.last
      end
      
      it { should have_flash_notice "Success" }
      it { should have_device @device }
      
    end
    
    context "WHEN: I submit an INVALID Device, the resulting page" do
      before(:each) do
        select "Apple", :from => "Vendor"
        click_button "Create Device"
        @device = Device.last
      end
      
      it { should have_error_message "Invalid Fields" }
      
    end

    
  end
  
end
