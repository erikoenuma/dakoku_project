class Authority < ApplicationRecord
  belongs_to :user_company

  enum authority: [ :employee, :group_admin, :admin ]
end
