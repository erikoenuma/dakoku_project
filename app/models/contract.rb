class Contract < ApplicationRecord
  validates :wage_per, length: { maximum: 255 }
  validates :start_at, presence: true
  validates :daily_reports_required, presence: true
  validates :role, presence: true, length: { maximum:255 }
  validates :under_contract, presence: true

  belongs_to :user_project
end
