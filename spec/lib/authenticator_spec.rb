require 'lib/authenticator'

describe Authenticator, '#new with a standard hash' do
  let(:hash) { { 'provider' => 'cas', 'uid' => 'user@dartmouth.edu',
                      'extra' => { 'uid' => '101' } } }

  context "A new instance, from a standard hash" do
    subject { Authenticator.new hash }

    its(:provider) { should == :cas }
    its(:realm) { should == :dartmouth }
    its(:uid) { should == 101 }
  end

  context "Created via the .from_hash custom constructor" do
    subject { Authenticator.from_hash hash }

    context "with a bad provider" do
      before { hash['provider'] = 'facebook' }
      it { should be_nil }
    end

    context "with a bad realm" do
      before { hash['uid'] = 'user@example.com' }
      it { should be_nil }
    end

    context "with a good hash" do
      it { should be_an_instance_of Authenticator }
    end
  end

end
