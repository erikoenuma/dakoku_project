class DailyReport < ApplicationRecord
  validates :date, presence: true

  belongs_to :user_project
end
