require File.dirname(__FILE__) + '/../spec_helper'

describe Resource do
  it "should be valid" do
    Resource.new.should be_valid
  end
end
