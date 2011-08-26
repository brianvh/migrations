require 'spec_helper'

describe Profile do
  
  before(:each) do
    @profile = Factory(:profile)
  end

  it "used_only_blitz? should be true if user has only ever used blitz" do
    @profile.used_email_clients = ["Blitz[Mail]"]
    @profile.should be_used_only_blitz
  end

  it "used_only_blitz? should not be true if user has used any other email client" do
    @profile.should_not be_used_only_blitz
  end
  
  it "missing_vital_attributes? should be false if all vital attributes have been set by a user" do
    @profile.should_not be_missing_vital_attributes
  end
  
  it "missing_vital_attributes? should be true if any vital attribute has not been set by a user" do
    @profile.uses_ira = nil
    @profile.should be_missing_vital_attributes
  end
  
end
