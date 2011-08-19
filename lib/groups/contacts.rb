module Groups
  module Contacts
    extend ActiveSupport::Concern

    included do
      has_many :contact_users, :class_name => "Contact", :foreign_key => "group_id"
      has_many :contacts, :through => :contact_users, :source => :user

      after_save :add_contact, :remove_contact
      attr_accessor :contact_id
      attr_reader :contact_name
    end

    module InstanceMethods

      def contacts_display
        @contacts_display ||= self.contacts.map(&:name).join(', ')
      end

      def members_for_contact_list
        contact_ids = contacts.map(&:id)
        members.select { |m| !contact_ids.include?(m.id) }.map { |m| [m.last_first, m.id] }
      end

      def add_contact
        return unless adding_contact?
        promote_to_contact
      end

      def remove_contact
        return unless removing_contact?
        demote_from_contact
      end

      def adding_contact?
        contact_id.blank? ? false : action == :choose_contact
      end

      def removing_contact?
        contact_id.nil? ? false : action == :clear_contact
      end

      def get_contact_user(contact_user_id)
        self.contact_users.where(:user_id => contact_user_id).first
      end

      def promote_to_contact
        new_contact = get_member_user(contact_id)
        @contact_name = new_contact.user.last_first
        new_contact.update_attribute :type, 'Contact'
      end

      def demote_from_contact
        contact = get_contact_user(contact_id)
        @contact_name = contact.user.last_first
        contact.update_attribute :type, 'Member'
      end

      private :add_contact, :adding_contact?, :promote_to_contact,
              :remove_contact, :removing_contact?, :demote_from_contact,
              :get_contact_user
    end
  end
end
