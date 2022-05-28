class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  has_many :attendantce_tracks, through: :user_projects

  has_one :user_company, dependent: :destroy
  has_one :company, through: :user_company

  def isEmployee
    return current_user.user_company != nil
  end

end
