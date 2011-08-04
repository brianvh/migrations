require 'spec_helper'

describe Device do
  
  before(:each) do
    @device = Factory(:device)
  end

  it "should have 'duh' for vendor when vendor_choice is 'Other' and vendor_other is 'duh'" do
    @device.vendor_choice = "Other" # test fails if this runs first!
    @device.vendor_other = "duh"
    @device.vendor.should == "duh"
  end

end
