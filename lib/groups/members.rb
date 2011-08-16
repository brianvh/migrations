module Groups
  module Members
    extend ActiveSupport::Concern

    included do
      has_many :member_users, :class_name => "Member", :foreign_key => "group_id"
      has_many :members, :through => :member_users, :source => :user

      after_save  :add_by_deptclass, :remove_by_deptclass, :remove_member
      attr_accessor :member_id
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

      def add_member(mem_id)
        member_users.create(:user_id => mem_id)
      end

      def remove_member
        return unless removing_member?
        member_user_to_remove.destroy unless member_user_to_remove.nil?
      end

      def removing_member?
        member_id.nil? ? false : action == :remove_member
      end

      def add_by_deptclass
        return unless adding_deptclass?
        deptclass_users.each { |member| add_member(member.id) }
        @members_added = deptclass_users.size
      end

      def remove_by_deptclass
        return unless removing_deptclass?
        @members_removed = deptclass_members_to_remove.size
        deptclass_members_to_remove.map(&:destroy)
      end

      def adding_deptclass?
        add_deptclass.blank? ? false : [:create, :add_deptclass].include?(action)
      end

      def removing_deptclass?
        remove_deptclass.blank? ? false : action == :remove_deptclass
      end

      def deptclass_members_to_remove
        @deptclass_members_to_remove ||= self.member_users.includes(:user).
          where('users.deptclass' => remove_deptclass)
      end

      def member_user_to_remove
        @member_user_to_remove ||= self.member_users.where(:user_id => member_id).first
      end

      def get_member_user(member_user_id)
        self.member_users.where(:user_id => member_user_id).first
      end

      private :add_member, :remove_member, :removing_member?,
              :add_by_deptclass, :adding_deptclass?, :member_user_to_remove,
              :remove_by_deptclass, :removing_deptclass?, :get_member_user,
              :deptclass_members_to_remove
    end
  end
end
