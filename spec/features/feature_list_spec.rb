require 'spec_helper'

describe "Feature list" do
  it "sees a list of known features" do
    visit jim.features_path

    expect(page).to have_selector(".time_travel.panel-danger")
    within(".time_travel") do
      expect(page).to have_content("time_travel")
      expect(page).to have_content("Traveling through time")
    end

    expect(page).to have_selector(".space_travel.panel-success")
    within(".space_travel") do
      expect(page).to have_content("space_travel")
    end
  end
end
