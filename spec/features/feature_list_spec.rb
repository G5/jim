require 'spec_helper'

describe "Feature list", type: :feature  do
  it "sees a list of known features" do
    visit jim.features_path

    expect(page).to have_content("features are not enabled")

    expect(page).to have_selector(".time_travel.panel-danger")
    within(".time_travel") do
      expect(page).to have_content("Time Travel")
      expect(page).to have_content("Traveling through time")
      expect(page).to have_selector(".collapse.in")

      within(".enablements") do
        expect(page).to have_content("disabled")
        expect(page).to have_content("Need flux capacitor")
      end

      within(".dependants") do
        expect(page).to have_content("Escape the Libyans")
        expect(page).to have_content("stolen plutonium")
      end

      within(".panel-footer") do
        expect(page).to have_content("Depends on delorean")
        expect(page).to have_selector(".label-success")
      end
    end

    expect(page).to have_selector(".space_travel.panel-success")
    within(".space_travel") do
      expect(page).to have_content("Space Travel")
      expect(page).to have_no_selector(".collapse.in")

      within(".enablements") do
        expect(page).to have_content("Environment Variable SHELL")
        expect(page).to have_content(ENV["SHELL"])
        expect(page).to have_content("Test /sh/")
        expect(page).to have_no_content("Example")

        expect(page).to have_content("Environment Variable USER")
        expect(page).to have_no_content(ENV["USER"])
        expect(page).to have_content("Test presence")
        expect(page).to have_content("redacted")
      end

      expect(page).to have_no_selector(".dependants")
      expect(page).to have_no_selector(".panel-footer")
    end
  end
end
