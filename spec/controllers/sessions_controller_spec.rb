require 'spec_helper'

describe SessionsController do
  subject { response }

  context "handling the :create action" do
    let(:auth_hash) { { 'provider' => 'cas', 'uid' => 'user@dartmouth.edu',
                        'extra' => { 'uid' => '1' } } }

    before { controller.stub!(:auth_hash).and_return(auth_hash) }

    context "for an invalid provider" do
      before do
        auth_hash['provider'] = 'facebook'
        get :create
      end

      it { should redirect_to not_authorized_path }
    end

    context "for an invalid realm" do
      before do
        auth_hash['uid'] = 'user@example.com'
        get :create
      end

      it { should redirect_to not_authorized_path }
    end

    context "for a known user" do
      let(:user) { create :client }

      before { auth_hash['extra']['uid'] = "#{user.uid}" }

      context "with no return URL" do
        before { get :create }

        it { should redirect_to root_path }

        it "should set the current_user" do
          controller.current_user.should == user
        end
      end

      context "with a return URL of '/groups'" do
        let(:url) { '/groups' }

        before { get :create, {}, :return_url => url }

        it { should redirect_to url }
      end
    end

    context "for a new user" do
      let(:user) { stub(:id => 1, :to_param => "101", :is_admin? => false) }

      before do
        User.should_receive(:create).once.and_return(user)
        get :create
      end

      it { should redirect_to user_path(user) }
    end
  end

end
