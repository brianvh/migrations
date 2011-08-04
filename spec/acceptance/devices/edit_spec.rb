require 'acceptance/acceptance_helper'

feature "Client user editing an existing Device" do

  subject { page }

  before(:each) do
    @user = login_as :client
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