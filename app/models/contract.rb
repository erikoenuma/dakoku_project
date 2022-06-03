class Contract < ApplicationRecord
  validates :wage_per, length: { maximum: 255 }
  validates :start_at, presence: true
  validates :daily_reports_required, inclusion: { in: [true, false] }
  validates :role, presence: true, length: { maximum:255 }
  validates :under_contract, inclusion: { in: [true, false] }

  belongs_to :user_project
end
