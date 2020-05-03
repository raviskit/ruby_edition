require 'rails_helper'

describe AbsencesController, type: :controller do

  context "without filters" do
    before { get :index }

    it "is successful" do
      expect(response).to have_http_status(200)
    end

    it "shows full list of absences" do
      expect(response.body.scan(/BEGIN:VEVENT/).count).to eq(42)
    end

    it "generates an ics file" do
      expect(response.headers["Content-Type"]).to eq("text/ical")
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"absences.ics\"")
    end
  end

  context "with userId filter" do
    before { get :index, params: { userId: 2735 } }

    it "returns the absence list of given user" do
      expect(response.body.scan(/BEGIN:VEVENT/).count).to eq(2)
    end

    it "returns user information" do
      expect(response.body).to include("Manuel is on vacation")
      expect(response.body).to include("Pfadfindersommerlager")
    end
  end

  context "with start and end date filters" do
    before { get :index, params: { startDate: "2017-01-01", endDate: "2017-02-01" } }

    it "returns absences in the give range" do
      expect(response.body).to include("Mike is sick")
      expect(response.body).to include("Mike is on vacation")
      expect(response.body).to include("Ines is on vacation")
      expect(response.body.scan(/BEGIN:VEVENT/).count).to be(3)
    end
  end
end