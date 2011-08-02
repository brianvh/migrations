require 'acceptance/acceptance_helper'

feature "Client user working with their Profile" do

  subject { page }

  before(:each) do
    @user = login_as :client
  end

  context "GIVEN: I'm a Client and need to create a new Profile" do
    before do
      email_client_choices
      visit new_profile_path
    end
    
    it { should have_header :profile, "Profile Information for #{@user.name}"}
    it { should have_select_field(:profile, :migrate_oracle_calendar) }
    
    context "WHEN: I submit a valid Profile, the resulting page" do
      before(:each) do
        select "Yes", :from => "Migrate my Oracle Calendar"
        click_button "Create Profile"
      end
      
      it {should have_flash_notice "Success"}
      
    end
    
  end
  
end
