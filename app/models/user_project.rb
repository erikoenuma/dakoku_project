class UserProject < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :attendance_tracks, dependent: :destroy
  has_one :contract, dependent: :destroy
  has_many :daily_reports, dependent: :destroy
  has_one :notice, dependent: :destroy

  # 開始した後終了しているかどうか
  def did_enter_finish
    return self.attendance_tracks.last.end_at == nil && self.attendance_tracks.last.start_at == nil
  end
end
