module Groups
  module Members
    extend ActiveSupport::Concern

    included do
      has_many :member_users, :class_name => "Member", :foreign_key => "group_id"
      has_many :members, :through => :member_users, :source => :user

      after_save  :add_member, :remove_member
      attr_accessor :member_id, :member_name
      attr_reader :member_name_error
    end

    module InstanceMethods

      def add_member
        return unless adding_member?
        return bad_member_name if lookup_member_name.nil?
        @member_name = lookup_member_name.name
        return existing_member if member_ids.include?(lookup_member_name.id)
        add_member_user(lookup_member_name.id)
      end

      def adding_member?
        member_name.blank? ? false : action == :add_member
      end

      def add_member_user(mem_id)
        member = self.member_users.create(:user_id => mem_id)
        add_calendars(member.user)
      end

      def lookup_member_name
        @lookup ||= User.lookup_by_name(member_name)
      end

      def bad_member_name
        @member_name_error = %("#{member_name}" is not a unique match in the DND.)
      end

      def existing_member
        @member_name_error = %("#{member_name}" is already a member of this group.)
      end

      def remove_member
        return unless removing_member?
        return if member_user_to_remove.nil?
        remove_calendars(member_user_to_remove.user)
        member_user_to_remove.destroy
      end

      def removing_member?
        member_id.nil? ? false : action == :remove_member
      end

      def member_user_to_remove
        @member_user_to_remove ||= self.member_users.where(:user_id => member_id).first
      end

      private :add_member, :adding_member?, :add_member_user,
              :lookup_member_name, :bad_member_name,
              :remove_member, :removing_member?, :member_user_to_remove
    end
  end
end
