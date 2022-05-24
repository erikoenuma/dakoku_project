class Company < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255 }
    validates :zipcode, length: { minimum: 7, maximum: 8 }
    validates :address, length: { maximum:255 }
    validates :phone, length: { minimum: 10, maximum: 11 }
    validates :email, length: { maximum: 255 }

    has_many :user_companies
    has_many :users, through: :user_companies

end
