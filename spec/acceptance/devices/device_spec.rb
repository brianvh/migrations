require 'acceptance/acceptance_helper'

feature "Client user working with their Devices" do

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
    it { should have_select_field(:device, :vendor) }
    
    context "WHEN: I submit a valid Device, the resulting page" do
      before(:each) do
        select "Apple", :from => "Vendor"
        click_button "Create Device"
      end
      
      it {should have_flash_notice "Success"}
      
    end
    
  end
  
  context "GIVEN: I'm a Client and I need to modify a Device" do
    before(:each) do
      device_vendor_choices
      @device = Device.new(:vendor => 'Lenovo')
      @user.devices << @device
      visit edit_device_path(@device)
    end

    it { should have_button('Update Device') }

    context "WHEN: I change the vendor to 'Dell' and submit the Device, the resulting page" do
      before do
        select "Dell", :from => "Vendor"
        click_button "Update Device"
      end

      it { should have_flash_notice "Success"}
      it { should have_content "Dell"}
    end

  end
  

end