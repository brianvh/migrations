require 'spec_helper'

describe "A new Client User instance" do

  subject { client }

  context "Created with both first and last name attributes" do
    let(:client) { build :client }

    its(:last_first) { should == 'Client, Joe' }
  end

  context "Created with a last name attribute" do
    let(:client) { build :client, :firstname => '' }

    its(:last_first) { should == 'Client' }
  end
end
