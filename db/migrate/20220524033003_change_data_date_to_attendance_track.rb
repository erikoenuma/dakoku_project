class ChangeDataDateToAttendanceTrack < ActiveRecord::Migration[6.0]
  def change
    change_column :attendance_tracks, :end_at, :datetime
    change_column :attendance_tracks, :start_at, :datetime
  end
end
