require 'acceptance/acceptance_helper'

feature "Client user editing their Profile" do

  background do
    @user = login_as :client
    email_client_choices
  end

  subject { page }
  
  context "GIVEN: I have a Profile in the system" do
    let(:create_my_profile) { @user.profiles << Factory(:profile) }
    let(:submit) {
      # check "email_choice_0"
      # check "email_choice_1"
      select "No", :from => :migrate_oracle_calendar
      click_button "Update Profile"
      }
  
    before { create_my_profile }  
    
    context "WHEN: I visit my Profile page" do
      before { visit profile_path @user.profiles.first }
      
      it { should have_header :profile, "Migration Profile for #{@user.name}" }
      it { should have_content 'Oracle Calendar to be migrated? Yes'}

      context "AND: I click the 'Edit Profile' link" do
        before { click_link 'Edit Profile' }
        
        it { should have_select_field :profile, :migrate_oracle_calendar }
        it { should have_button 'Update Profile' }
        
        context "AND: I change Migrate Oracle Calendar to 'No' and click 'Update Profile'" do
          before { submit }
          
          it { should have_flash_notice "Success" }
          it { should have_content 'Oracle Calendar to be migrated? No'}
        end
      end
    end
  end
end
