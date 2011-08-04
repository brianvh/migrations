require 'spec_helper'

describe 'A New Group instance' do

  subject { group }

  let(:group) { build(:group, :name => name) }
  let(:name) { 'A Group' }

  context "with an empty name" do
    let(:name) { '' }

    it { should_not be_valid }
  end

  context "with the same name as an existing group" do
    before { create(:group, :name => name) }

    it { should_not be_valid }
  end

  context "with a unique name" do
    it { should be_valid }
  end

end

describe 'A Group instance, with a valid name' do
  subject { group }

  let(:group) { build(:group, :deptclass => dept_string) }
  let(:dept_string) { depts.join(', ') }
  let(:depts) { ['Foo'] }
  let(:user) { mock('user') }

  context "and an empty deptclass" do
    let(:dept_string) { '' }

    it { should be_valid }
    its(:deptclass) { should be_empty }
  end

  context "and a deptclass of 'Foo'" do
    its(:deptclass) { should == depts }
    its(:deptclass_display) { should == dept_string }

    context "with no associated users" do
      before { group.should_receive(:deptclass_users).once.and_return([]) }

      it { should_not be_valid }
    end

    context "with at least 1 associated user" do
      before { group.should_receive(:deptclass_users).once.and_return([user]) }

      it { should be_valid }
    end
  end

  context "and a deptclass of 'Foo, Bar'" do
    let(:depts) { ['Foo', 'Bar'] }
    
    its(:deptclass) { should == depts }
    its(:deptclass_display) { should == depts.join(', ') }
  end
end
