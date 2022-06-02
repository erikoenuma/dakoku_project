class Project < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255}
    validates :billing_destination_email, length: { maximum: 255}
    validates :billing_destination_manager, length: { maximum: 255}

    has_many :user_projects, dependent: :destroy
    has_many :users, through: :user_projects
    has_many :attendance_tracks, through: :user_projects
    has_many :contracts, through: :user_projects
    belongs_to :company, optional: true

    def belongs_to_user
        return self.company_id == nil
    end
end
