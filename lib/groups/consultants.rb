module Groups
  module Consultants
    extend ActiveSupport::Concern

    included do
      has_many :consultant_users, :class_name => "Consultant", :foreign_key => "group_id"
      has_many :consultants, :through => :consultant_users, :source => :user

      after_save :add_consultant, :remove_consultant
      attr_accessor :consultant_id
      attr_reader :consultant_name
    end

    module InstanceMethods

      def consultants_display
        @consultants_display ||= self.consultants.map(&:name).join(', ')
      end

      def get_consultant_user(consultant_user_id)
        self.consultant_users.where(:user_id => consultant_user_id).first
      end

      def add_consultant
        return unless adding_consultant?
        assign_consultant
      end

      def remove_consultant
        return unless removing_consultant?
        unassign_consultant
      end

      def adding_consultant?
        consultant_id.blank? ? false : action == :choose_consultant
      end

      def removing_consultant?
        consultant_id.nil? ? false : action == :clear_consultant
      end

      def assign_consultant
        consultant = consultant_users.create(:user_id => consultant_id)
        @consultant_name = consultant.user.last_first
      end

      def unassign_consultant
        consultant = get_consultant_user(consultant_id)
        @consultant_name = consultant.user.last_first
        consultant.destroy
      end

      private :add_consultant, :adding_consultant?, :assign_consultant,
              :remove_consultant, :removing_consultant?, :unassign_consultant,
              :get_consultant_user
    end
  end
end