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

describe 'An existing group instance' do
  subject { group }

  let(:group) { create :group }
  let(:dept_string) { depts.join(', ') }

  context 'adding a single deptclass' do
    let(:depts) { ['Foo'] }

    before do
      group.action = 'add_deptclass'
      group.add_deptclass = dept_string
    end

    its(:add_deptclass) { should == depts }

  end

  context 'removing a single deptclass' do
    let(:depts) { ['Foo'] }

    before do
      group.action = 'remove_deptclass'
      group.remove_deptclass = dept_string
    end

    its(:remove_deptclass) { should == depts }

  end
end

describe 'A Group with a member from an exiting deptclass' do
  subject { @group }

  let(:member) { create :client, :firstname => 'Jack' }
  let(:dept) { member.deptclass }

  before do
    @group = create :group, :deptclass => dept
    @group = Group.find(@group.id)
  end

  its(:members) { should have(1).member }

  context 'adding the existing deptclass, with no new members' do
    before do
      @group.update_attributes :add_deptclass => dept, :action => :add_deptclass
    end

    its(:members) { should have(1).member }
  end

  context 'adding the existing deptclass, with 1 new member' do
    before do
      @new_member = create :client, :firstname => 'Jill'
      @group.update_attributes :add_deptclass => dept, :action => :add_deptclass
    end

    its(:members) { should have(2).members }
    its(:member_ids) { should == [member.id, @new_member.id] }
  end
end
