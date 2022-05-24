require "application_system_test_case"

class AttendanceTracksTest < ApplicationSystemTestCase
  setup do
    @attendance_track = attendance_tracks(:one)
  end

  test "visiting the index" do
    visit attendance_tracks_url
    assert_selector "h1", text: "Attendance Tracks"
  end

  test "creating a Attendance track" do
    visit attendance_tracks_url
    click_on "New Attendance Track"

    fill_in "End at", with: @attendance_track.end_at
    fill_in "Start at", with: @attendance_track.start_at
    fill_in "User project", with: @attendance_track.user_project_id
    click_on "Create Attendance track"

    assert_text "Attendance track was successfully created"
    click_on "Back"
  end

  test "updating a Attendance track" do
    visit attendance_tracks_url
    click_on "Edit", match: :first

    fill_in "End at", with: @attendance_track.end_at
    fill_in "Start at", with: @attendance_track.start_at
    fill_in "User project", with: @attendance_track.user_project_id
    click_on "Update Attendance track"

    assert_text "Attendance track was successfully updated"
    click_on "Back"
  end

  test "destroying a Attendance track" do
    visit attendance_tracks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Attendance track was successfully destroyed"
  end
end
