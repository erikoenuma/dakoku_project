class AttendanceTrack < ApplicationRecord
  belongs_to :user_project

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
