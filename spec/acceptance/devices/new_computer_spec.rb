require 'acceptance/acceptance_helper'

feature "Client user creating a new 'Computer' device" do

  background do
    @user = login_as :client, :uid => 58789, :name => nil
    device_vendor_choices
    device_kind_choices
  end

  subject { page }
  
  context "GIVEN: I need to create a new 'Computer' Device" do
    let(:submit) {
      select "Apple (Intel)", :from => 'Vendor'
      select "Laptop", :from => 'Kind'
      click_button "Create Device"
      }
    
    context "WHEN: I visit the New Computer page" do
      before { visit new_device_path(:type => 'computer') }
      
      it { should have_header :device, 'New Computer Device Information' }
      it { should have_select_field :device, :vendor_choice }
      it { should have_button 'Create Device'}
      
      context "WHEN: I select 'Apple' from Vendor and 'Phone' from Kind" do
        before { submit }
      
        context "THEN: I should be successful" do
          it { should have_flash_notice "Success" }
          it { should have_header :device, 'Device Information for Apple (Intel) Laptop'}
        end
      end

      context "WHEN: I select 'Apple' from Vendor and nothing from Kind" do
        let(:submit) {
          select "Apple", :from => 'Vendor'
          click_button "Create Device"
          }

        before { submit }
      
        context "THEN: I should not be successful" do
          it { should have_error_message "Invalid Fields" }
          it { should have_header :device, 'New Computer Device Information'}
        end
      end

    end
  end
end
