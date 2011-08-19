module Groups
  module Deptclass
    extend ActiveSupport::Concern

    included do
      after_save  :add_by_deptclass, :remove_by_deptclass
    end

    module InstanceMethods

      def add_deptclass
        deptclass
      end

      def add_deptclass=(depts)
        self.deptclass = depts
      end

      def remove_deptclass
        deptclass
      end

      def remove_deptclass=(depts)
        self.deptclass = depts
      end

      def members_added
        @members_added || 0
      end

      def members_removed
        @members_removed || 0
      end

      def add_by_deptclass
        return unless adding_deptclass?
        deptclass_users.each { |member| add_member_user(member.id) }
        @members_added = deptclass_users.size
      end

      def remove_by_deptclass
        return unless removing_deptclass?
        @members_removed = deptclass_members_to_remove.size
        deptclass_members_to_remove.each { |mem| remove_member_user(mem) }
      end

      def adding_deptclass?
        add_deptclass.blank? ? false : [:create, :add_deptclass].include?(action)
      end

      def remove_member_user(member_user)
        remove_calendars(member_user.user)
        member_user.destroy
      end

      def removing_deptclass?
        remove_deptclass.blank? ? false : action == :remove_deptclass
      end

      def deptclass_members_to_remove
        @deptclass_members_to_remove ||= self.member_users.includes(:user).
          where('users.deptclass' => remove_deptclass)
      end

      def get_member_user(member_user_id)
        self.member_users.where(:user_id => member_user_id).first
      end

      private :add_by_deptclass, :adding_deptclass?, :get_member_user,
              :remove_by_deptclass, :removing_deptclass?,
              :deptclass_members_to_remove
    end
  end
end
