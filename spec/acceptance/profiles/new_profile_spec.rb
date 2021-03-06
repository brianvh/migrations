require 'acceptance/acceptance_helper'

feature "Client user creating their Profile" do

  background do
    @user = login_as :client, :uid => 58789, :name => nil
    email_client_choices
  end

  subject { page }
  
  context "GIVEN: I need to create a new Profile" do
    let(:submit) {
      select "Yes", :from => :migrate_oracle_calendar
      click_button "Create Profile"
      }
    
    context "WHEN: I visit the New Profile page" do
      before { visit new_profile_path }
      
      it { should have_header :profile, "Migration Profile for #{@user.name}" }
      it { should have_select_field(:profile, :migrate_oracle_calendar) }
      it { should have_button 'Create Profile'}
      
      context "WHEN: I select 'Yes' from 'Migrate Oracle Calendar?' and submit the form" do
        before { submit }
      
        context "THEN: I should be successful" do
          it { should have_flash_notice "Success" }
        end
      end

    end
  end
end
