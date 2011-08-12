require 'acceptance/acceptance_helper'

feature "Client user edits a Resource" do

  background do
    @user = login_as :client, :uid => 58789, :name => nil
    @resource = Factory(:resource)
    @user.resources << @resource
  end

  subject { page }

  context "GIVEN: I own a Resource in the system" do
    let(:submit) {
      select "Yes", :from => :migrate
      click_button "Update Resource"
      }
      
    context "WHEN: I visit my status page" do
      before { visit user_path @user }
      
      it { should have_resource @user.resources.first}

      context "WHEN: I click it's name" do
        before { click_link "#{@user.resources.first.name}" }
          
        it { should have_header :resource, "Resource Information for #{@user.resources.first.name}" }
        
        context "WHEN: I click the Edit link" do
          before { click_link "Edit" }

          it { should have_select_field(:resource, :disposition) }
          
          context "WHEN: I select 'Yes' from the Migrate? select and submit the form" do
            before { submit }
          
            it { should have_flash_notice "Success"}
          end
        end
      end
    end
  end
end