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
end
