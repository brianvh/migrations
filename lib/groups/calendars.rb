module Groups
  module Calendars
    extend ActiveSupport::Concern

    included do
      has_many :calendar_resources, :class_name => "Calendar", :foreign_key => "group_id"
      has_many :calendars, :through => :calendar_resources, :source => :resource
    end

    module InstanceMethods

      def add_calendars(member)
        return if member.primary_resource_ownership_ids.empty?
        member.primary_resource_ownership_ids.each { |cal_id| add_calendar(cal_id) }
      end

      def add_calendar(calendar_id)
        self.calendar_resources.create(:resource_id => calendar_id)
      end

      def remove_calendars(member)
        return if member.primary_resource_ownership_ids.empty?
        member.primary_resource_ownership_ids.each { |cal_id| remove_calendar(cal_id) }
      end

      def remove_calendar(calendar_id)
        self.calendar_resources.find_by_resource_id(calendar_id).destroy
      end

      private :add_calendar, :add_calendars, :remove_calendar, :remove_calendars
    end
  end
end
