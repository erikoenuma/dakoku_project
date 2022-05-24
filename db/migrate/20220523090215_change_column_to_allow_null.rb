class ChangeColumnToAllowNull < ActiveRecord::Migration[6.0]
  def change
    change_column :attendance_tracks, :end_at, :date, null: true
  end

  def down
    change_column :attendance_tracks, :end_at, :date, null: false
  end
end
