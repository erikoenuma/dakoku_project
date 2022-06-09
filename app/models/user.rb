class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  has_many :attendantce_tracks, through: :user_projects
  has_many :contract, through: :user_projects
  has_many :daily_reports, through: :user_projects

  has_one :user_company, dependent: :destroy
  has_one :company, through: :user_company

  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6, maximum: 255 }

  def company_user
    return self.user_company != nil
  end

  def employee
    return company_user && self.user_company.authority.authority == "employee"
  end

  def group_admin
    return company_user && self.user_company.authority.authority == "group_admin"
  end

  def admin
    return company_user && self.user_company.authority.authority == "admin"
  end

end
