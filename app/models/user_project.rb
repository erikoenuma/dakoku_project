class UserProject < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :attendance_tracks
end
