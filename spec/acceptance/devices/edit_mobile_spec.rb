require 'acceptance/acceptance_helper'

feature "Client user editing an existing 'Mobile' Device" do

  background do
    @user = login_as :client, :uid => 58789, :name => nil
    device_mobile_vendor_choices
  end

  subject { page }
  
  context "GIVEN: I have one Lenovo Laptop device in the system" do
    let(:create_my_device) { @user.devices << Factory(:mobile) }
    let(:vendor) { 'Android' }
    let(:submit) { 
      select vendor, :from => 'Vendor'
      click_button "Update Device"
      }
    
    before { create_my_device }
    
    context "WHEN: I visit the Device Information page" do
      before { visit device_path @user.devices.first }
      
      it { should have_header :device, 'Device Information for Apple Phone' }
      
      context "AND: I click the 'Edit' link" do
        before { click_link 'Edit' }
        
        it { should have_select_field :device, :vendor_choice }
        it { should have_button 'Update Device'}
        
        context "AND: I change the vendor to Android and click 'Update Device'" do
          before { submit }
          
          it { should have_flash_notice "Success" }
          it { should have_header :device, 'Device Information for Android Phone'}
        end
      end
    end
  end  
end
