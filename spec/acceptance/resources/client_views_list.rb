require 'acceptance/acceptance_helper'

feature "Client user views a list of assigned Resources" do

  background do
    @user = login_as :client, :uid => 58789, :name => nil
    @user.resources << Factory(:resource)
    @user.profiles << Factory(:profile)
    @other_resource = Factory(:resource, :name => "Does Not Belong To Me")
  end

  subject { page }

  context "GIVEN: I am the owner of an Oracle Calendar Resource" do
    context "WHEN: I visit the list of my Resources" do
      before { visit resources_path }
      
      it { should have_header :resource, "Resources List" }
      it { should have_resource @user.resources.first }
      it { should_not have_resource @other_resource }
    end
  end
end