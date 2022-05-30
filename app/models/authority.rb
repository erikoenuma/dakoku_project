class Authority < ApplicationRecord
  belongs_to :user_company

  enum authority: [ :employee, :group_admin, :admin ]

  def to_ja 
    case self.authority
    when "employee" then
      return "従業員"
    when "group_admin" then
      return "グループ管理者"
    when "admin" then
      return "管理者"
    end
  end
  
end
