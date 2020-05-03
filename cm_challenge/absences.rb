require_relative './api'
require 'icalendar'

module CmChallenge
  class Absences
    def initialize(options = {})
      @absences = CmChallenge::Api.absences
      @members = CmChallenge::Api.members
      apply_filters(options)
    end

    def to_ical
      cal = Icalendar::Calendar.new

      @absences.each do |absence|
        member = @members.detect { |member| member[:user_id] == absence[:user_id] }
        cal.event do |e|
          e.dtstart     = Icalendar::Values::Date.new(absence[:start_date].gsub('-', ''))
          e.dtend       = Icalendar::Values::Date.new(absence[:end_date].gsub('-', ''))
          e.summary     = absence_type(absence, member)
          e.description = absence[:member_note]
          e.ip_class    = "PRIVATE"
        end
      end

      cal.publish
      cal
    end

    private

    def apply_filters(options)
      filter_users(options["userId"]) if options["userId"].present?
      filter_dates(options["startDate"], options["endDate"]) if options["startDate"].present? && options["endDate"].present?
    end

    def filter_users(user_id)
      @absences = @absences.select{ |a| a[:user_id] == user_id.to_i }
    end

    def filter_dates(start_date, end_date)
      @absences = @absences.select do |absence|
        Date.parse(absence[:start_date]) >= Date.parse(start_date) && Date.parse(absence[:end_date]) <= Date.parse(end_date)
      end
    end

    def absence_type(absence, member)
      case absence[:type]
      when "vacation"
        "#{member[:name]} is on vacation"
      when "sickness"
        "#{member[:name]} is sick"
      else
        "#{member[:name]} is absent"
      end
    end
  end
end
