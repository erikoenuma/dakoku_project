class UserCompany < ApplicationRecord
  belongs_to :user
  belongs_to :company
  has_many :authorities
end
