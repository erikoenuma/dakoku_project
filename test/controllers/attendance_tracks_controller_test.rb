require 'test_helper'

class AttendanceTracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attendance_track = attendance_tracks(:one)
  end

  test "should get index" do
    get attendance_tracks_url
    assert_response :success
  end

  test "should get new" do
    get new_attendance_track_url
    assert_response :success
  end

  test "should create attendance_track" do
    assert_difference('AttendanceTrack.count') do
      post attendance_tracks_url, params: { attendance_track: { end_at: @attendance_track.end_at, start_at: @attendance_track.start_at, user_project_id: @attendance_track.user_project_id } }
    end

    assert_redirected_to attendance_track_url(AttendanceTrack.last)
  end

  test "should show attendance_track" do
    get attendance_track_url(@attendance_track)
    assert_response :success
  end

  test "should get edit" do
    get edit_attendance_track_url(@attendance_track)
    assert_response :success
  end

  test "should update attendance_track" do
    patch attendance_track_url(@attendance_track), params: { attendance_track: { end_at: @attendance_track.end_at, start_at: @attendance_track.start_at, user_project_id: @attendance_track.user_project_id } }
    assert_redirected_to attendance_track_url(@attendance_track)
  end

  test "should destroy attendance_track" do
    assert_difference('AttendanceTrack.count', -1) do
      delete attendance_track_url(@attendance_track)
    end

    assert_redirected_to attendance_tracks_url
  end
end
