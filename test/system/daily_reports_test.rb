require "application_system_test_case"

class DailyReportsTest < ApplicationSystemTestCase
  setup do
    @daily_report = daily_reports(:one)
  end

  test "visiting the index" do
    visit daily_reports_url
    assert_selector "h1", text: "Daily Reports"
  end

  test "creating a Daily report" do
    visit daily_reports_url
    click_on "New Daily Report"

    fill_in "Contents", with: @daily_report.contents
    fill_in "Date", with: @daily_report.date
    fill_in "User project", with: @daily_report.user_project_id
    click_on "Create Daily report"

    assert_text "Daily report was successfully created"
    click_on "Back"
  end

  test "updating a Daily report" do
    visit daily_reports_url
    click_on "Edit", match: :first

    fill_in "Contents", with: @daily_report.contents
    fill_in "Date", with: @daily_report.date
    fill_in "User project", with: @daily_report.user_project_id
    click_on "Update Daily report"

    assert_text "Daily report was successfully updated"
    click_on "Back"
  end

  test "destroying a Daily report" do
    visit daily_reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Daily report was successfully destroyed"
  end
end
