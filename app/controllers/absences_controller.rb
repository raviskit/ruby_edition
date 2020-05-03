require_relative "../../cm_challenge/absences"

class AbsencesController < ApplicationController
  def index
    cal = CmChallenge::Absences.new(absences_params).to_ical
    send_data cal.to_ical, type: 'text/ical', disposition: 'attachment', filename: "absences.ics"
  end

  private

  def absences_params
    params.permit(:userId, :startDate, :endDate).to_hash
  end
end
