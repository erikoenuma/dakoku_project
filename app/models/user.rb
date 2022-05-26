class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  has_many :attendantce_tracks, through: :user_projects, dependent: :destroy

  has_many :user_companies
  has_many :companies, through: :user_companies
  has_one :authority, through: :user_companies, dependent: :destroy

end
