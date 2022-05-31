# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # ユーザーがログイン済みかどうか
    if user.present?
      can :manage, AttendanceTrack
      # 個人ユーザー
      if user.user_company.nil?
        # 企業プロジェクトはreadのみ
        can :read, Project, active: true

        can :manage, Project do |project|
          project.company == nil
        end
        can :manage, User, user: user
        # 企業ユーザーのページにはいけない
        cannot :manage, User do |user|
          user.company != nil
        end
      else 
        # グループ管理者
        if user.user_company.authority.authority != "employee"
          can :manage, Project do |project|
            project.company == user.company
          end
          can :read, User
          can [:assign, :validate_employee], Company
          can :manage, Contract

          # 管理者
          if user.user_company.authority.authority == "admin"
            # binding.pr
            can :users, Company
            can :manage, User do |u|
              u.company = user.company
            end
          end
        end
      end
    end
  end

end
