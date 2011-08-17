require 'acceptance/acceptance_helper'

feature "Admin user views a list of all Resources" do

  background do
    @user = login_as :admin, :uid => 55497, :name => nil
    @resource_a = Factory(:resource, :name => "Foo")
    @resource_b = Factory(:resource, :name => "-bar")
  end

  subject { page }

  context "GIVEN: I am an admin user" do
    context "WHEN: I visit the master list of Resources" do
      before { visit resources_path }
      
      it { should have_header :resource, "Resources List" }
      it { should have_resource @resource_a }
      it { should have_resource @resource_b }
    end
  end
end