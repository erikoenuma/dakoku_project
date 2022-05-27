class UserCompany < ApplicationRecord
  belongs_to :user
  belongs_to :company
  has_one :authority, dependent: :destroy
  accepts_nested_attributes_for :authority
end
