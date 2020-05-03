require_relative '../cm_challenge/absences'
require 'icalendar'

RSpec.describe 'Absences' do
  describe "#to_ical" do

    subject { CmChallenge::Absences.new.to_ical }

    it "lists all the events" do
      expect(subject.events.count).to eq(42)
    end

    it "shows correct data" do
      expect(subject.events.first.summary).to eq("Mike is sick")
      expect(subject.events.first.description).to eq("")
      expect(subject.events.first.dtstart.to_s).to eq("2017-01-13")
      expect(subject.events.first.dtend.to_s).to eq("2017-01-13")
    end
  end
end
