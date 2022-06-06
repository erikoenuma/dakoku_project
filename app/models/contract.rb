class Contract < ApplicationRecord
  validates :wage_per, length: { maximum: 255 }
  validates :start_at, presence: true
  validate :end_at_before_start_at
  # validate :not_assigned_before
  validates :daily_reports_required, inclusion: { in: [true, false] }
  validates :role, presence: true, length: { maximum:255 }
  validates :under_contract, inclusion: { in: [true, false] }

  belongs_to :user_project

  # validation

  # 終了日時は開始日時より前
  def end_at_before_start_at
    if self.end_at != nil && self.start_at > self.end_at then
      errors.add(:end_at, "はアサイン開始日より後の日付けになるようにしてください。")
    end
  end
end
