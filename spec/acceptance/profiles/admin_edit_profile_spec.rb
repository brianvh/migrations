require 'acceptance/acceptance_helper'

feature "Admin user editing a Client's Profile" do

  background do
    @user = login_as :support, :uid => 55497, :name => nil
    email_client_choices
  end

  subject { page }
  
  context "GIVEN: a Profile for a Client exists in the system" do
    let(:create_client_profile) {
      @client = Factory(:client)
      @client.profiles << Factory(:profile)
      }
    let(:submit) {
      select "No", :from => :migrate_oracle_calendar
      click_button "Update Profile"
      }
  
    before { create_client_profile }
    
    context "WHEN: I visit the Client's Profile page" do
      before { visit profile_path @client.profiles.first }
      
      it { should have_header :profile, "Migration Profile for #{@client.name}" }
      it { should have_content 'Oracle Calendar to be migrated? Yes' }
      it { should have_content 'Comfort level: 3' }

      context "AND: I click the 'Edit Profile' link" do
        before { click_link 'Edit Profile' }
        
        it { should have_select_field :profile, :migrate_oracle_calendar }
        it { should have_select_field :profile, :comfort_level }
        it { should have_button 'Update Profile' }
        
        context "AND: I change Migrate Oracle Calendar to 'No' and click 'Update Profile'" do
          before { submit }
          
          it { should have_flash_notice "Success" }
          it { should have_header :profile, "Migration Profile for #{@client.name}" }
          it { should have_content 'Oracle Calendar to be migrated? No'}
        end
      end
    end
  end
end
