class CreateAttendanceTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :attendance_tracks do |t|
      t.date :start_at, null: false
      t.date :end_at, null: false
      t.references :user_project, null: false, foreign_key: true
    end
  end
end
