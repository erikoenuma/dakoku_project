class Project < ApplicationRecord
    has_many :user_projects, dependent: :destroy
    has_many :users, through: :user_projects
    has_many :attendance_tracks, through: :user_projects
    belongs_to :company, optional: true

    def belongs_to_company
        return self.company_id != nil
    end
end
