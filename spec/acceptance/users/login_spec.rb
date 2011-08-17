require 'acceptance/acceptance_helper'

feature "Handling a user returning from a WebAuth login" do

  subject { page }

  context "WHEN: I login as Client user Throckmorton P. Scribblemonger, " + 
            "my default entry page" do
    before(:each) do
      @user = login_as :client, :uid => 58789, :name => nil
    end

    it { should have_header :user, "User Status for #{@user.name}" }
    it { should have_logout_link @user }
    
  end
end
