require 'spec_helper'

describe "Feature list" do
  it "sees a list of known features" do
    visit jim.features_path
    expect(page).to have_content("time_travel")
    expect(page).to have_content("Traveling through time")
  end
end
