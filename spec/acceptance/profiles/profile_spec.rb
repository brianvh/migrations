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
    
    it { should have_header :profile, "Migration Profile for #{@user.name}"}
    it { should have_select_field(:profile, :migrate_oracle_calendar) }
    
    context "WHEN: I submit a valid Profile, the resulting page" do
      before(:each) do
        select "Yes", :from => "Migrate my Oracle Calendar"
        click_button "Create Profile"
      end
      
      it {should have_flash_notice "Success"}
      
    end
    
  end
  
  context "GIVEN: I'm a Client and I need to modify my Profile" do
    before(:each) do
      email_client_choices
      @user.profiles << Profile.new(:migrate_oracle_calendar => true)
      visit edit_profile_path(@user.profiles.first)
    end

    it { should have_button('Update Profile') }

    context "WHEN: I change my calendar migration to 'No' and submit the Profile, the resulting page" do
      before do
        select "No", :from => "Migrate my Oracle Calendar"
        click_button "Update Profile"
      end

      it { should have_flash_notice "Success"}
      it { should have_content "Calendar WILL NOT"}
    end

  end
  
end
