class AttendanceTrack < ApplicationRecord
  validates :start_at, presence: true
  validate :end_at_after_start_at
  belongs_to :user_project

  # 終了時間が開始時間より後になるようにする
  def end_at_after_start_at
    if self.end_at != nil && self.start_at > self.end_at then
      errors.add(:end_at, "時刻は開始時刻より後の時刻になるようにしてください。")
    end
  end

  def day
    self.start_at_ja.strftime("%m月%d日")
  end

  def time
    "#{start_time}～#{ end_at.nil? ? "": "#{end_time}"}"
  end

  def duration_minutes
    if self.end_at.nil?
      return 0
    else
      # 差（秒）
      diff = (self.end_at - self.start_at)
      return diff    
    end
  end

  def start_at_ja 
    self.start_at.in_time_zone('Tokyo')
  end

  private

  def start_time
    self.start_at.in_time_zone('Tokyo').strftime("%H:%M")
  end

  def end_time
    self.end_at.in_time_zone('Tokyo').strftime("%H:%M")
  end

end
