# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # ユーザーがログイン済みかどうか
    if user.present?
      can :manage, AttendanceTrack do |track|
        track.user_project.user == user
      end

      # 自分の日報のみ編集可能
      can [:edit, :update], DailyReport do |report|
        report.user_project.user == user
      end

      # 個人ユーザー
      if user.user_company.nil?
        # 企業プロジェクトはreadのみ active: trueは外部キー持ってるかどうか
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
          can :manage, Project, company: user.company
          can :read, User
          can [:assign, :validate_employee], Company
          can :manage, Contract
          can :read, DailyReport do |report|
            report.user_project.project.company == user.company
          end

          # 管理者
          if user.user_company.authority.authority == "admin"
            can :users, Company
            can :manage, User, company: user.company
          end
        end
      end
    end
  end

end
