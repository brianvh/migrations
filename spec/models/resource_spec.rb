require 'spec_helper'

describe "Setting secondary owner by name" do

  let(:client) { Client.create(:name => "Alan S. German") }
  let(:resource) { build(:resource, :secondary_owner => client) }
  let(:secondary_owner_name) { "alan german" }
  
  let(:update) { resource.update_attributes(:secondary_owner_name => secondary_owner_name) }
  
  context "with an empty name" do

    subject { resource }

    let(:secondary_owner_name) { '' }

    it { should be_valid }
    its(:secondary_owner) { should == client }
    
  end
    
  subject { update }
  
  context "with a bad dnd name given" do
    let(:secondary_owner_name) { '20r afhag' }
    
    it { should == false }

  end
  
  context "with a good dnd name given" do
    
    it { should == true }
    
  end
  
end
